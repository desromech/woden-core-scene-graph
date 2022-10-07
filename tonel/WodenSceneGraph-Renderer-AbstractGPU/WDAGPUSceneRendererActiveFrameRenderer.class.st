"
I am renderer for a specific frame.
I hold references to resources that are still in flight on the GPU that cannot be garbage collected until my job is finished.
"
Class {
	#name : #WDAGPUSceneRendererActiveFrameRenderer,
	#superclass : #WDFrameRenderer,
	#instVars : [
		'renderer',
		'stateTracker',
		'activeResources',
		'activeSlabResource',
		'commandQueue',
		'activeResourceDictionary',
		'currentObjectVertexBinding',
		'currentObjectPrimitiveTopology',
		'depthFunction',
		'depthTestingEnabled',
		'depthWriteMask',
		'alphaBlendingEnabled',
		'isInDepthOnlyPass',
		'hasSkinningState'
	],
	#classVars : [
		'BloomBlurPasses',
		'PrimitiveTopologyMap',
		'SSAOBlurPasses',
		'ScreenRoughnessBlurPasses'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #initialization }
WDAGPUSceneRendererActiveFrameRenderer class >> initialize [
	SSAOBlurPasses := 2.
	ScreenRoughnessBlurPasses := 2.
	BloomBlurPasses := 4.
	
	PrimitiveTopologyMap := Dictionary newFromPairs: { 
		WDPrimitiveTopologyPoints uniqueInstance . AGPU_POINTS.
		WDPrimitiveTopologyLines uniqueInstance . AGPU_LINES.
		WDPrimitiveTopologyLineStrip uniqueInstance . AGPU_LINE_STRIP.
		WDPrimitiveTopologyTriangles uniqueInstance . AGPU_TRIANGLES.
		WDPrimitiveTopologyTriangleStrip uniqueInstance . AGPU_TRIANGLE_STRIP.
	}.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> abortRecording [
	self freeActiveResources.
	stateTracker := nil.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> activateMaterial: material withVertexBinding: vertexBinding primitiveTopology: primitiveTopology [
	| validMaterial vertexBindingHandle |
	vertexBinding ifNil: [ ^ false ].
	validMaterial := material ifNil: [ renderer resourceCache defaultMaterial ].
	
	self
		setAlphaBlendingEnabled: validMaterial hasAlphaBlending;
		setDepthTestingEnable: validMaterial hasDepthTesting writeMask: validMaterial writesDepth.
	
	vertexBindingHandle := self validVertexBindingFor: vertexBinding.
	stateTracker
		setVertexLayout: vertexBindingHandle first;
		useVertexBinding: vertexBindingHandle second;
		setPrimitiveType: (PrimitiveTopologyMap at: primitiveTopology).
	currentObjectVertexBinding := vertexBinding.
	currentObjectPrimitiveTopology := primitiveTopology.

	^ validMaterial emitActivationCommandsOn: self

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> allocateAndRenderShadowMapFor: shadowMapSet [
	| atlasAllocator atlasElements lightSource atlasExtent viewportOffset viewportExtent  viewportScale viewportExtentScale |
	atlasAllocator := renderer resourceCache shadowMapAtlasAllocator.
	atlasElements := shadowMapSet cameraStates collect: [ :each | atlasAllocator allocate ].
	((atlasElements anySatisfy: [ :each | each isNil ]) or: [
	shadowMapSet renderingScenes allSatisfy: [ :each | each opaqueRenderingObjects isEmpty ] ]) ifTrue: [
		shadowMapSet lightSource castShadows: false.
		^ self
	].

	lightSource := shadowMapSet lightSource.
	atlasElements doWithIndex: [ :atlasElement :index |
		self renderShadowMapFor: (shadowMapSet renderingScenes at: index) atlasElement: atlasElement lightSource: lightSource
	].

	viewportScale := (Vector2 x: 0.5 y: 0.5).
	viewportOffset := (Vector2 x: 0.5 y: 0.5).
		
	renderer device hasTopLeftNdcOrigin = renderer device hasBottomLeftTextureCoordinates ifTrue: [ 
		viewportScale y: viewportScale y negated
	].

	atlasExtent := atlasElements first atlasExtent.
	viewportExtent := atlasElements first extent.
	viewportExtentScale := viewportExtent / atlasExtent.

	lightSource
		shadowMapViewportScale: viewportScale * viewportExtentScale;
		shadowMapViewportOffsets: (atlasElements collect: [:atlasElement |
			viewportOffset * viewportExtentScale + (atlasElement offset/atlasExtent)
		])
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> beginRecordingCommandsOn: aStateTracker queue: aCommandQueue [
	stateTracker := aStateTracker.
	commandQueue := aCommandQueue.
	activeResources := OrderedCollection new.
	activeSlabResource := OrderedCollection new.
	activeResourceDictionary := Dictionary new.
	stateTracker beginRecordingCommands.
	self resetCurrentActiveState.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindBlurTextureSource: sourceTexture [
	stateTracker useShaderResources: (activeResourceDictionary at: {sourceTexture} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding bindSampledTextureView: sourceTexture getOrCreateFullView inSlot: 1.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindCameraState: cameraState [
	stateTracker useShaderResources: (self getOrCreateCameraStateBinding: cameraState) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindComputeCameraState: cameraState [
	stateTracker useComputeShaderResources: (self getOrCreateCameraStateBinding: cameraState) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindComputeLightingState: lightingState [
	stateTracker useComputeShaderResources: (self getOrCreateLightingStateBinding: lightingState) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindHDRColorBuffer: hdrColorBuffer [
	stateTracker useShaderResources: (activeResourceDictionary at: hdrColorBuffer ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding bindSampledTextureView: hdrColorBuffer getOrCreateFullView inSlot: 1.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindLeftEye: leftEyeTexture rightEye: rightEyeTexture [
	stateTracker useShaderResources: (activeResourceDictionary at: {leftEyeTexture . rightEyeTexture} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding
			bindSampledTextureView: (self validTextureViewHandleFor: leftEyeTexture fallbackTextureWith: [[renderer resourceCache transparentTexture2D]]) inSlot: 1;
			bindSampledTextureView: (self validTextureViewHandleFor: rightEyeTexture fallbackTextureWith: [[renderer resourceCache transparentTexture2D]])inSlot: 2.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindLightingState: lightingState [
	stateTracker useShaderResources: (self getOrCreateLightingStateBinding: lightingState) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindObjectState: objectState [
	stateTracker useShaderResources: (activeResourceDictionary at: objectState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateObjectState.
		binding writeState: objectState with: WDAGPUObjectStateUniformBufferWriter.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindOpaqueDepthBuffer: opaqueDepthBufferView normalGBuffer: normalGBuffer [
	stateTracker useShaderResources: (activeResourceDictionary at: {opaqueDepthBufferView . normalGBuffer} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding
			bindSampledTextureView: opaqueDepthBufferView inSlot: 1;
			bindSampledTextureView: normalGBuffer getOrCreateFullView inSlot: 2.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindOpaqueDepthBuffer: opaqueDepthBufferView normalGBuffer: normalGBuffer specularGBuffer: specularGBuffer [
	stateTracker useShaderResources: (activeResourceDictionary at: {opaqueDepthBufferView . normalGBuffer . specularGBuffer} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding
			bindSampledTextureView: opaqueDepthBufferView inSlot: 1;
			bindSampledTextureView: normalGBuffer getOrCreateFullView inSlot: 2;
			bindSampledTextureView: specularGBuffer getOrCreateFullView inSlot: 3.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindOpaqueDepthBuffer: opaqueDepthBufferView normalGBuffer: normalGBuffer specularGBuffer: specularGBuffer glossColorBuffer: glossColorBuffer roughColorBuffer: roughColorBuffer [
	stateTracker useShaderResources: (activeResourceDictionary at: {opaqueDepthBufferView . normalGBuffer . specularGBuffer . glossColorBuffer . roughColorBuffer} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding
			bindSampledTextureView: opaqueDepthBufferView inSlot: 1;
			bindSampledTextureView: normalGBuffer getOrCreateFullView inSlot: 2;
			bindSampledTextureView: specularGBuffer getOrCreateFullView inSlot: 3;
			bindSampledTextureView: glossColorBuffer getOrCreateFullView inSlot: 4;
			bindSampledTextureView: roughColorBuffer getOrCreateFullView inSlot: 5.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindOpaqueDepthBuffer: opaqueDepthBufferView opaqueColorBuffer: opaqueColorBuffer ssaoTexture: ssaoTexture staticReflectionTexture: staticReflectionTexture screenSpaceReflectionTexture: screenSpaceReflectionTexture [
	stateTracker useShaderResources: (activeResourceDictionary at: {opaqueDepthBufferView . opaqueColorBuffer . ssaoTexture . staticReflectionTexture . screenSpaceReflectionTexture} ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
		binding
			bindSampledTextureView: opaqueDepthBufferView inSlot: 1;
			bindSampledTextureView: opaqueColorBuffer getOrCreateFullView inSlot: 2;
			bindSampledTextureView: ssaoTexture getOrCreateFullView inSlot: 3;
			bindSampledTextureView: staticReflectionTexture getOrCreateFullView inSlot: 4;
			bindSampledTextureView: screenSpaceReflectionTexture getOrCreateFullView inSlot: 5.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> bindPoseState: poseState [
	hasSkinningState := poseState notNil.
	poseState ifNil: [ ^ self ].
	stateTracker useShaderResources: (activeResourceDictionary at: poseState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocatePoseState.
		binding writeState: poseState with: WDAGPUPoseStateUniformBufferWriter.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> composeStereoLeft: leftEyeFramebuffer right: rightEyeFramebuffer into: framebuffer mode: composeMode [

	| outputFramebufferHandle shaderSignature leftEyeTexture rightEyeTexture |
	shaderSignature := renderer resourceCache rendererShaderSignature.
	outputFramebufferHandle := self validFramebufferFor: framebuffer.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache viewportOutputRenderPass framebuffer: outputFramebufferHandle bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: (renderer resourceCache stereoComposeShaderFor: composeMode) entryPoint: 'main'.		

	leftEyeTexture := leftEyeFramebuffer colorAttachments first.
	rightEyeTexture := rightEyeFramebuffer colorAttachments first.
	self bindLeftEye: leftEyeTexture rightEye: rightEyeTexture.
		
	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> convertedCameraState: aCameraState framebufferExtent: framebufferExtent [
	^ aCameraState shallowCopy
		projectionMatrix: renderer resourceCache projectionNDCAdjustMatrix * aCameraState projectionMatrix;
		lightGridColumns: WDAGPUSceneRenderer lightGridColumns;
		lightGridRows: WDAGPUSceneRenderer lightGridRows;
		lightGridSlices: WDAGPUSceneRenderer lightGridSlices;
		hasTopLeftNDCOrigin: renderer device hasTopLeftNdcOrigin;
		hasBottomLeftTextureCoordinates: renderer device hasBottomLeftTextureCoordinates;
		framebufferWidth: framebufferExtent x;
		framebufferHeight: framebufferExtent y;
		yourself
]

{ #category : #material }
WDAGPUSceneRendererActiveFrameRenderer >> emitDepthOnlyOpaqueSurfaceMaterialActivationCommandsFor: material [
	| locationMask |
	material hasOpaqueRendering ifFalse: [ ^ false ].
	locationMask := currentObjectVertexBinding locationMask bitAnd: renderer resourceCache depthOnlyVertexAttributesForMask.
	
	stateTracker
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask hasSkinning: hasSkinningState) entryPoint: 'main';
		setFragmentStage: renderer resourceCache genericDepthOnlySurfaceFragmentShader entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #material }
WDAGPUSceneRendererActiveFrameRenderer >> emitDuplicatedMetallicRoughnessLiquidMaterialActivationCommands: material [
	| locationMask |
	(isInDepthOnlyPass and: [material hasAlphaMasking not]) ifTrue: [ ^ self emitDepthOnlyOpaqueSurfaceMaterialActivationCommandsFor: material ].
	
	locationMask := currentObjectVertexBinding locationMask.
	
	stateTracker
		useShaderResources: (activeResourceDictionary at: material ifAbsentPut: [ 
			| binding |
			binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
			binding
				writeState: material with: WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter;
				bindSampledTextureView: (self validTextureViewHandleFor: material baseColorTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 1;
				bindSampledTextureView: (self validTextureViewHandleFor: material emissiveTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 2;
				bindSampledTextureView: (self validTextureViewHandleFor: material normalTexture fallbackTextureWith: [renderer resourceCache neutralNormalTexture]) inSlot: 3;
				bindSampledTextureView: (self validTextureViewHandleFor: material occlusionTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 4;
				bindSampledTextureView: (self validTextureViewHandleFor: material metallicRoughnessTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 5.
			activeSlabResource add: binding.
			binding
		]) bindingHandle;
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: currentObjectVertexBinding locationMask hasSkinning: hasSkinningState) entryPoint: 'main';
		setFragmentStage: (isInDepthOnlyPass
			ifTrue: [ renderer resourceCache duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShader ]
			ifFalse: [ material hasAlphaBlending
				ifTrue: [ renderer resourceCache duplicatedMetallicRoughnessLiquidTranslucentFragmentShader ]
				ifFalse: [renderer resourceCache duplicatedMetallicRoughnessLiquidOpaqueFragmentShader]]) entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #material }
WDAGPUSceneRendererActiveFrameRenderer >> emitEnvironmentMapMaterialActivationCommands: material [
	| locationMask |
	(isInDepthOnlyPass and: [material hasAlphaMasking not]) ifTrue: [ ^ self emitDepthOnlyOpaqueSurfaceMaterialActivationCommandsFor: material ].
	
	locationMask := currentObjectVertexBinding locationMask.
	
	stateTracker
		useShaderResources: (activeResourceDictionary at: material ifAbsentPut: [ 
			| binding |
			binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
			binding
				writeState: material with: WDAGPUEnvironmentMapMaterialUniformBufferWriter;
				bindSampledTextureView: (self validTextureViewHandleFor: material colorTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 1.
				
			activeSlabResource add: binding.
			binding
		]) bindingHandle;
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask hasSkinning: hasSkinningState) entryPoint: 'main';
		setFragmentStage: (isInDepthOnlyPass
			ifTrue: [ renderer resourceCache environmentMapDepthOnlyFragmentShaderSource ]
			ifFalse: [ material hasAlphaBlending
				ifTrue: [ renderer resourceCache environmentMapTranslucentFragmentShader ]
				ifFalse: [ renderer resourceCache environmentMapOpaqueFragmentShader ]]) entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #material }
WDAGPUSceneRendererActiveFrameRenderer >> emitMetallicRoughnessMaterialActivationCommands: material [
	| locationMask |
	(isInDepthOnlyPass and: [material hasAlphaMasking not]) ifTrue: [ ^ self emitDepthOnlyOpaqueSurfaceMaterialActivationCommandsFor: material ].
	
	locationMask := currentObjectVertexBinding locationMask.
	
	stateTracker
		useShaderResources: (activeResourceDictionary at: material ifAbsentPut: [ 
			| binding |
			binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
			binding
				writeState: material with: WDAGPUMetallicRoughnessMaterialUniformBufferWriter;
				bindSampledTextureView: (self validTextureViewHandleFor: material baseColorTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 1;
				bindSampledTextureView: (self validTextureViewHandleFor: material emissiveTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 2;
				bindSampledTextureView: (self validTextureViewHandleFor: material normalTexture fallbackTextureWith: [renderer resourceCache neutralNormalTexture]) inSlot: 3;
				bindSampledTextureView: (self validTextureViewHandleFor: material occlusionTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 4;
				bindSampledTextureView: (self validTextureViewHandleFor: material metallicRoughnessTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 5.
			activeSlabResource add: binding.
			binding
		]) bindingHandle;
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: currentObjectVertexBinding locationMask hasSkinning: hasSkinningState) entryPoint: 'main';
		setFragmentStage: (isInDepthOnlyPass
			ifTrue: [ renderer resourceCache metallicRoughnessDepthOnlyFragmentShader ]
			ifFalse: [material hasAlphaBlending
				ifTrue: [ renderer resourceCache metallicRoughnessTranslucentFragmentShader ]
				ifFalse: [renderer resourceCache metallicRoughnessOpaqueFragmentShader]]) entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> emitRenderingCommandsForMeshPrimitive: meshPrimitive [
	(self activateMaterial: meshPrimitive material withVertexBinding: meshPrimitive vertexBinding primitiveTopology: meshPrimitive topology) ifFalse: [ ^ self ].
		
	meshPrimitive indices ifNil: [
		stateTracker
			drawArrays: meshPrimitive vertexBinding validVertexCount instance_count: 1 first_vertex: 0 base_instance: 0
	] ifNotNil: [ :indicesAccessor |
		| handle |
		handle := self validBufferHandleForAccessor: indicesAccessor.
		handle ifNil: [ ^ self ].
		stateTracker
			useIndexBufferAt: handle
				offset: indicesAccessor byteOffset + indicesAccessor bufferView byteOffset
				index_size: indicesAccessor componentType size;
			drawElements: indicesAccessor count instance_count: 1 first_index: 0 base_vertex: 0 base_instance: 0
	].

]

{ #category : #material }
WDAGPUSceneRendererActiveFrameRenderer >> emitUnlitMaterialActivationCommands: material [
	| locationMask |
	(isInDepthOnlyPass and: [material hasAlphaMasking not]) ifTrue: [ ^ self emitDepthOnlyOpaqueSurfaceMaterialActivationCommandsFor: material ].

	locationMask := currentObjectVertexBinding locationMask.
	
	stateTracker
		useShaderResources: (activeResourceDictionary at: material ifAbsentPut: [ 
			| binding |
			binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
			binding
				writeState: material with: WDAGPUUnlitMaterialUniformBufferWriter;
				bindSampledTextureView: (self validTextureViewHandleFor: material colorTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 1.
				
			activeSlabResource add: binding.
			binding
		]) bindingHandle;
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask hasSkinning: hasSkinningState) entryPoint: 'main';
		setFragmentStage: (isInDepthOnlyPass
			ifTrue: [ renderer resourceCache unlitDepthOnlyFragmentShaderSource ]
			ifFalse: [ material hasAlphaBlending
				ifTrue: [ renderer resourceCache unlitTranslucentFragmentShader ]
				ifFalse: [ renderer resourceCache unlitOpaqueFragmentShader ]]) entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> finishExecution [
	commandQueue finishExecution.
	self freeActiveResources.
]

{ #category : #private }
WDAGPUSceneRendererActiveFrameRenderer >> freeActiveResources [
	activeSlabResource ifNotNil: [ 
		activeSlabResource do: [ :each | each free ].
		activeSlabResource := nil.
	].
	activeResources := nil.
	activeResourceDictionary := nil.
	renderer resourceCache uploadBuffer free.
	self resetCurrentActiveState
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> getOrCreateCameraStateBinding: cameraState [
	^ activeResourceDictionary at: cameraState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateCameraState.
		binding writeState: cameraState with: WDAGPUCameraStateUniformBufferWriter.
		binding bindStorageBuffer: renderer resourceCache computeScratchStorageBuffer inSlot: 1.
		activeSlabResource add: binding.
		binding
	]

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> getOrCreateLightingStateBinding: lightingState [
	^ activeResourceDictionary at: lightingState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateLightingState.
		binding
			writeState: lightingState with: WDAGPUGlobalLightingStateUniformBufferWriter;
			bindStorageBuffer: renderer resourceCache lightStateBuffer inSlot: 1;
			bindStorageBuffer: renderer resourceCache lightClusterBuffer
 inSlot: 2;
			bindStorageBuffer: renderer resourceCache tileLightIndexListBuffer inSlot: 3;
			bindStorageBuffer: renderer resourceCache lightGridBuffer inSlot: 4;
			
			bindSampledTextureView: renderer resourceCache shadowMapAtlasTextureSamplingView inSlot: 5;
			bindSampledTextureView: renderer resourceCache brdfLutTexture getOrCreateFullView inSlot: 6;
			bindSampledTextureView: (self validTextureViewHandleFor: lightingState ambientDiffuseLightProbeTexture fallbackTextureWith: [renderer resourceCache transparentTextureCube ]) inSlot: 7;
			bindSampledTextureView: (self validTextureViewHandleFor: lightingState ambientSpecularLightProbeTexture fallbackTextureWith: [renderer resourceCache transparentTextureCube ]) inSlot: 8.
		activeSlabResource add: binding.
		binding
	]
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrameRenderer >> isInDepthOnlyPass [
	^ isInDepthOnlyPass
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> makeLightingStateForRenderingSceneState: renderingSceneState [
	^ renderingSceneState lightingStateInViewSpaceWithMaxNumberOfLights: WDAGPUSceneRenderer maxLightCapacity
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordAndFlushCommandsOn: aStateTracker queue: aCommandQueue with: aBlock [
	self beginRecordingCommandsOn: aStateTracker queue: aCommandQueue.
	[
		aBlock cull: self.
		stateTracker endRecordingAndFlushCommands
	] on: Error do: [ :e |
		self abortRecording.
		e pass
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForBloomEffectForRenderingScene: renderingSceneState framebuffer: framebuffer intermediateFramebuffers: intermediateFramebuffers cameraState: mainCameraState [
	| shaderSignature bloomExtent |
	
	mainCameraState bloomStrength <= 0.0 ifTrue: [ ^ self ].

	shaderSignature := renderer resourceCache rendererShaderSignature.
	bloomExtent := intermediateFramebuffers bloomExtent.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache bloomRenderPass framebuffer: intermediateFramebuffers bloomPingFramebuffer  bundle_content: 0;
		setViewport: 0 y: 0 w: bloomExtent x h: bloomExtent y;
		setScissor: 0 y: 0 w: bloomExtent x h: bloomExtent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache bloomSelectionFragmentShader entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindBlurTextureSource: intermediateFramebuffers hdrColorBufferTexture.

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass.

	1 to: BloomBlurPasses do: [ :blurPass |
		"Blur horizontal pass."		
		stateTracker
			beginRenderPass: renderer resourceCache bloomRenderPass framebuffer: intermediateFramebuffers bloomPongFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: bloomExtent x h: bloomExtent y;
			setScissor: 0 y: 0 w: bloomExtent x h: bloomExtent y;
			setFragmentStage: renderer resourceCache blurHorizontalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: intermediateFramebuffers bloomPingTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
			
		"Blur vertical pass."		
		stateTracker
			beginRenderPass: renderer resourceCache bloomRenderPass framebuffer: intermediateFramebuffers bloomPingFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: bloomExtent x h: bloomExtent y;
			setScissor: 0 y: 0 w: bloomExtent x h: bloomExtent y;
			setFragmentStage: renderer resourceCache blurVerticalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: intermediateFramebuffers bloomPongTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
	].

	stateTracker
		beginRenderPass: (renderer resourceCache hdrTranslucentContinueRenderPassWithSampleCount: renderingSceneState sampleCount) framebuffer: intermediateFramebuffers hdrTranslucentFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache downsampleFragmentShader entryPoint: 'main';
		setBlendState: 1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ONE colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ZERO destAlphaFactor: AGPU_BLENDING_ONE alphaOperation: AGPU_BLENDING_OPERATION_ADD.

	self bindBlurTextureSource: intermediateFramebuffers bloomPingTexture.
	
	stateTracker
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForCombiningOpaqueReflections: intermediateFramebuffers cameraState: mainCameraState [
	| extent |

	extent := intermediateFramebuffers extent.
	stateTracker
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache opaqueReflectionCombinationFragmentShader entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindOpaqueDepthBuffer: intermediateFramebuffers depthStencilBufferSamplingView  opaqueColorBuffer: intermediateFramebuffers hdrOpaqueColorBuffer ssaoTexture: intermediateFramebuffers ssaoPingTexture staticReflectionTexture: intermediateFramebuffers staticReflectionTexture screenSpaceReflectionTexture: intermediateFramebuffers screenSpaceReflectionTexture.

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderable: renderable [
	renderable emitRenderingCommandsWithRenderer: self
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderingBackgroundObjectsInScene: renderingSceneState framebufferExtent: framebufferExtent [
	renderingSceneState cameraLayers do: [ :eachCameraLayer |
		eachCameraLayer backgroundObjects isNotEmpty ifTrue: [
			self bindCameraState: (self convertedCameraState: eachCameraLayer cameraState framebufferExtent: framebufferExtent).
			eachCameraLayer backgroundObjects do: [ :each |
				self recordCommandsForRenderingObject: each
			]
		].
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderingObject: renderingObject [
	self
		bindObjectState: renderingObject objectState;
		bindPoseState: renderingObject poseState.
	self recordCommandsForRenderable: renderingObject renderable
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderingOpaqueObjectsInScene: renderingSceneState framebufferExtent: framebufferExtent [
	renderingSceneState cameraLayers reverseDo: [ :eachCameraLayer |
		eachCameraLayer opaqueRenderingObjects isNotEmpty ifTrue: [ 
			self bindCameraState: (self convertedCameraState: eachCameraLayer cameraState framebufferExtent: framebufferExtent).
			eachCameraLayer opaqueRenderingObjects do: [ :each |
				self recordCommandsForRenderingObject: each
			]
		].
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderingTranslucentObjectsInScene: renderingSceneState framebufferExtent: framebufferExtent [
	renderingSceneState cameraLayers do: [ :eachCameraLayer |
		eachCameraLayer translucentRenderingObjects isNotEmpty ifTrue: [ 
			self bindCameraState: (self convertedCameraState: eachCameraLayer cameraState framebufferExtent: framebufferExtent).
			eachCameraLayer translucentRenderingObjects do: [ :each |
				self recordCommandsForRenderingObject: each
			]
		].
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForScreenRoughComputationFor: intermediateFramebuffers [
	| shaderSignature screenRoughExtents screenRoughTextures screenRoughFramebuffers previousTexture pingTextureIndex blurExtent pingTexture pingFramebuffer pongTexture pongFramebuffer |

	shaderSignature := renderer resourceCache rendererShaderSignature.
	screenRoughExtents := intermediateFramebuffers screenRoughExtents.
	screenRoughTextures := intermediateFramebuffers screenRoughTextures.
	screenRoughFramebuffers := intermediateFramebuffers screenRoughFramebuffers.
	
	previousTexture := intermediateFramebuffers hdrOpaqueColorBuffer.
	pingTextureIndex := screenRoughExtents size - 1.
	
	"Downsample the color output."	
	1 to: pingTextureIndex do: [ :index |
		| extent |
		extent := screenRoughExtents at: index.

		stateTracker
			resetGraphicsPipeline;
			beginRenderPass: renderer resourceCache hdrBlurRenderPass framebuffer: (screenRoughFramebuffers at: index) bundle_content: 0;
			setViewport: 0 y: 0 w: extent x h: extent y;
			setScissor: 0 y: 0 w: extent x h: extent y;
			setShaderSignature: shaderSignature handle;
			useShaderResources: shaderSignature samplersBinding;
			setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
			setFragmentStage: renderer resourceCache downsampleFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: previousTexture.

		stateTracker
			setCullMode: AGPU_CULL_MODE_NONE;
			setDepthState: false writeMask: false function: AGPU_ALWAYS;
			setPrimitiveType: AGPU_TRIANGLES;
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
			
		previousTexture := screenRoughTextures at: index
	].

	blurExtent := intermediateFramebuffers screenRoughExtents at: pingTextureIndex.
	pingTexture := intermediateFramebuffers screenRoughTextures at: pingTextureIndex.
	pingFramebuffer := intermediateFramebuffers screenRoughFramebuffers at: pingTextureIndex.

	pongTexture := intermediateFramebuffers screenRoughTextures last.
	pongFramebuffer := intermediateFramebuffers screenRoughFramebuffers last.

	1 to: ScreenRoughnessBlurPasses do: [ :blurPass |
		"Blur horizontal pass."
		stateTracker
			beginRenderPass: renderer resourceCache hdrBlurRenderPass framebuffer: pongFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: blurExtent x h: blurExtent y;
			setScissor: 0 y: 0 w: blurExtent x h: blurExtent y;
			setFragmentStage: renderer resourceCache blurHorizontalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: pingTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
			
		"Blur vertical pass."		
		stateTracker
			beginRenderPass: renderer resourceCache hdrBlurRenderPass framebuffer: pingFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: blurExtent x h: blurExtent y;
			setScissor: 0 y: 0 w: blurExtent x h: blurExtent y;
			setFragmentStage: renderer resourceCache blurVerticalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: pongTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForScreenSpaceAmbientOcclusionComputationFor: intermediateFramebuffers cameraState: mainCameraState [
	| shaderSignature ssaoExtent |

	shaderSignature := renderer resourceCache rendererShaderSignature.
	ssaoExtent := intermediateFramebuffers ssaoExtent.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache screenSpaceAmbientOcclusionRenderPass framebuffer: intermediateFramebuffers ssaoPingFramebuffer  bundle_content: 0;
		setViewport: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
		setScissor: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache screenSpaceAmbientOcclusionComputationFragmentShader entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindOpaqueDepthBuffer: intermediateFramebuffers depthStencilBufferSamplingView normalGBuffer: intermediateFramebuffers normalGBufferTexture.

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass.

	1 to: SSAOBlurPasses do: [ :blurPass |
		"Blur horizontal pass."		
		stateTracker
			beginRenderPass: renderer resourceCache screenSpaceAmbientOcclusionRenderPass framebuffer: intermediateFramebuffers ssaoPongFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
			setScissor: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
			setFragmentStage: renderer resourceCache blurHorizontalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: intermediateFramebuffers ssaoPingTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
			
		"Blur vertical pass."		
		stateTracker
			beginRenderPass: renderer resourceCache screenSpaceAmbientOcclusionRenderPass framebuffer: intermediateFramebuffers ssaoPingFramebuffer bundle_content: 0;
			setViewport: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
			setScissor: 0 y: 0 w: ssaoExtent x h: ssaoExtent y;
			setFragmentStage: renderer resourceCache blurVerticalPassFragmentShader entryPoint: 'main'.

		self bindBlurTextureSource: intermediateFramebuffers ssaoPongTexture.

		stateTracker
			drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
			endRenderPass.
	]
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForScreenSpaceReflectionComputationFor: intermediateFramebuffers cameraState: mainCameraState [
	| shaderSignature extent screenRoughTextures screenRoughTexture |
	
	self recordCommandsForScreenRoughComputationFor: intermediateFramebuffers.
	
	screenRoughTextures := intermediateFramebuffers screenRoughTextures.
	screenRoughTexture := screenRoughTextures at: screenRoughTextures size - 1.

	shaderSignature := renderer resourceCache rendererShaderSignature.
	extent := intermediateFramebuffers extent.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache reflectionRenderPass framebuffer: intermediateFramebuffers screenSpaceReflectionFramebuffer  bundle_content: 0;
		setViewport: 0 y: 0 w: extent x h: extent y;
		setScissor: 0 y: 0 w: extent x h: extent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: (renderer resourceCache screenSpaceReflectionComputationFragmentShader) entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindOpaqueDepthBuffer: intermediateFramebuffers depthStencilBufferSamplingView normalGBuffer: intermediateFramebuffers normalGBufferTexture specularGBuffer: intermediateFramebuffers specularGBufferTexture glossColorBuffer: intermediateFramebuffers hdrOpaqueColorBuffer roughColorBuffer: screenRoughTexture.

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForStaticReflectionComputationFor: intermediateFramebuffers cameraState: mainCameraState [
	| shaderSignature extent |

	shaderSignature := renderer resourceCache rendererShaderSignature.
	extent := intermediateFramebuffers extent.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache reflectionRenderPass framebuffer: intermediateFramebuffers staticReflectionFramebuffer  bundle_content: 0;
		setViewport: 0 y: 0 w: extent x h: extent y;
		setScissor: 0 y: 0 w: extent x h: extent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: (renderer resourceCache staticReflectionComputationFragmentShader) entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindOpaqueDepthBuffer: intermediateFramebuffers depthStencilBufferSamplingView normalGBuffer: intermediateFramebuffers normalGBufferTexture specularGBuffer: intermediateFramebuffers specularGBufferTexture.

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordLightGridComputationCommands [
	| workgroupCountX workgroupCountY workgroupCountZ workgroupCount |
	workgroupCountX := (WDAGPUSceneRenderer lightGridColumns + 3) // 4.
	workgroupCountY := (WDAGPUSceneRenderer lightGridRows + 3) // 4.
	workgroupCountZ := (WDAGPUSceneRenderer lightGridSlices + 3) // 4.

	workgroupCount := (WDAGPUSceneRenderer lightGridCellCount + 63) // 64.

	"Compute the per-cluster bounding boxes."
	stateTracker
		setComputeStage: renderer resourceCache lightGridComputationShader entryPoint: 'main';
		dispatchCompute: workgroupCountX group_count_y: workgroupCountY group_count_z: workgroupCountZ;
		memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER dest_stage: AGPU_PIPELINE_STAGE_COMPUTE_SHADER source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ;

		setComputeStage: renderer resourceCache lightClusterListBeginComputationShader entryPoint: 'main';
		dispatchCompute: 1 group_count_y: 1 group_count_z: 1;
		memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER dest_stage: AGPU_PIPELINE_STAGE_COMPUTE_SHADER source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ;

		setComputeStage: renderer resourceCache lightClusterListComputationShader entryPoint: 'main';
		dispatchCompute: workgroupCount group_count_y: 1 group_count_z: 1;
		memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER dest_stage: AGPU_PIPELINE_STAGE_FRAGMENT_SHADER source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| intermediateFramebuffers outputFramebufferHandle shaderSignature sampleCount hasReverseDepth initialDepth mainCameraState convertedLightingState normalDepthFunction |
	sampleCount := renderingSceneState sampleCount.
	hasReverseDepth := renderingSceneState hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	normalDepthFunction := hasReverseDepth ifTrue: [ AGPU_GREATER_EQUAL ] ifFalse: [ AGPU_LESS_EQUAL ].

	depthFunction := normalDepthFunction.
	intermediateFramebuffers := self validIntermediateFramebuffersFor: framebuffer
		sampleCount: sampleCount
		initialDepth: initialDepth.
	shaderSignature := renderer resourceCache rendererShaderSignature.
	
	renderer resourceCache shadowMapAtlasAllocator reset.	
	renderingSceneState cameraLayers do: [ :cameraLayer |
		cameraLayer shadowMapSets do: [ :shadowMapSet |
			self allocateAndRenderShadowMapFor: shadowMapSet
		]
	].

	mainCameraState := self convertedCameraState: (renderingSceneState mainCameraState ifNil: [WDCameraState new]) framebufferExtent: framebuffer extent.

	convertedLightingState := self makeLightingStateForRenderingSceneState: renderingSceneState.
	convertedLightingState numberOfLights > 0 ifTrue: [ 
		self uploadLightStates: convertedLightingState lights.
	].

	stateTracker
		resetComputePipeline;
		setShaderSignature: shaderSignature handle.

	"Depth-only prepass."
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: (renderer resourceCache depthOnlyRenderPassWithSampleCount: sampleCount initialDepth: initialDepth) framebuffer: intermediateFramebuffers depthOnlyFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.
	isInDepthOnlyPass := true.

	self
		recordCommandsForRenderingOpaqueObjectsInScene: renderingSceneState framebufferExtent: framebuffer extent.

	stateTracker
		endRenderPass.
		
	self
		bindComputeCameraState: mainCameraState;
		bindComputeLightingState: convertedLightingState.
	self recordLightGridComputationCommands.

	"Opaque render pass"
	depthTestingEnabled := true.
	depthWriteMask := true.
	depthFunction := normalDepthFunction. "TODO: Attempt to use AGPU_EQUAL instead."
	isInDepthOnlyPass := false.
	stateTracker
		beginRenderPass: (renderer resourceCache hdrOpaqueRenderPassWithSampleCount: sampleCount) framebuffer: intermediateFramebuffers hdrOpaqueFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setDepthState: true writeMask: true function: depthFunction.

	self
		bindLightingState: convertedLightingState;
		recordCommandsForRenderingBackgroundObjectsInScene: renderingSceneState framebufferExtent: framebuffer extent.

		
	depthTestingEnabled := true.
	depthWriteMask := true.
	depthFunction := AGPU_EQUAL.
	stateTracker
		setDepthState: true writeMask: true function: depthFunction.
	self recordCommandsForRenderingOpaqueObjectsInScene: renderingSceneState framebufferExtent: framebuffer extent.
		
	stateTracker endRenderPass.
	
	self
		recordCommandsForScreenSpaceAmbientOcclusionComputationFor: intermediateFramebuffers cameraState: mainCameraState;
		recordCommandsForStaticReflectionComputationFor: intermediateFramebuffers cameraState: mainCameraState;
		recordCommandsForScreenSpaceReflectionComputationFor: intermediateFramebuffers cameraState: mainCameraState.
		
	"Translucent render pass."
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: (renderer resourceCache hdrTranslucentRenderPassWithSampleCount: sampleCount) framebuffer: intermediateFramebuffers hdrTranslucentFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding.
		
	self
		recordCommandsForCombiningOpaqueReflections: intermediateFramebuffers cameraState: mainCameraState.
	depthTestingEnabled := true.
	depthWriteMask := false.
	depthFunction := normalDepthFunction.
	stateTracker
		setDepthState: true writeMask: false function: depthFunction.
	self
		bindLightingState: convertedLightingState;
		recordCommandsForRenderingTranslucentObjectsInScene: renderingSceneState framebufferExtent: framebuffer extent.
	stateTracker endRenderPass.

	depthFunction := nil.
	depthTestingEnabled := nil.
	depthWriteMask := nil.
	alphaBlendingEnabled := nil.
	
	"Bloom"
	self recordCommandsForBloomEffectForRenderingScene: renderingSceneState framebuffer: framebuffer intermediateFramebuffers: intermediateFramebuffers cameraState: mainCameraState.
	
	"For the exposure level."
	outputFramebufferHandle := self validFramebufferFor: framebuffer.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache viewportOutputRenderPass framebuffer: outputFramebufferHandle bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: (renderer resourceCache toneMappingOperatorShaderFor: mainCameraState toneMappingOperator) entryPoint: 'main'.

	self
		bindCameraState: mainCameraState;
		bindHDRColorBuffer: (intermediateFramebuffers hdrColorBufferTexture).

	stateTracker
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: false writeMask: false function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;
		endRenderPass
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> renderShadowMapFor: shadowMapCameraLayer [
	| shadowCastingLightSource convertedCameraState hasReverseDepth initialDepth shaderSignature atlasElement atlasExtent viewportOffset viewportExtent viewportExtentScale |

	atlasElement := renderer resourceCache shadowMapAtlasAllocator allocate.
	shadowCastingLightSource := shadowMapCameraLayer shadowCastingLightSource.

	atlasElement ifNil: [
		shadowMapCameraLayer castShadows: false.
		^ self
	].

	shadowCastingLightSource
		shadowMapViewportScale: (Vector2 x: 0.5 y: 0.5);
		shadowMapViewportOffset: (Vector2 x: 0.5 y: 0.5).
		
	renderer device hasTopLeftNdcOrigin = renderer device hasBottomLeftTextureCoordinates ifTrue: [ 
		shadowCastingLightSource shadowMapViewportScale y: shadowCastingLightSource shadowMapViewportScale y negated
	].

	atlasExtent := atlasElement atlasExtent.
	viewportOffset := atlasElement offset.
	viewportExtent := atlasElement extent.
	viewportExtentScale := viewportExtent / atlasExtent.
	shadowCastingLightSource
		shadowMapViewportScale: shadowCastingLightSource shadowMapViewportScale * viewportExtentScale;
		shadowMapViewportOffset: shadowCastingLightSource shadowMapViewportOffset * viewportExtentScale + (viewportOffset/atlasExtent).
		
	hasReverseDepth := shadowMapCameraLayer hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	shaderSignature := renderer resourceCache rendererShaderSignature.
	depthFunction := hasReverseDepth ifTrue: [ AGPU_GREATER_EQUAL ] ifFalse: [ AGPU_LESS_EQUAL ].

	convertedCameraState := self convertedCameraState: shadowMapCameraLayer cameraState framebufferExtent: viewportExtent.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.

	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache shadowMapRenderPass
			framebuffer: renderer resourceCache shadowMapAtlasFramebuffer bundle_content: 0;
		setViewport: viewportOffset x y: viewportOffset y w: viewportExtent x h: viewportExtent y;
		setScissor: viewportOffset x y: viewportOffset y w: viewportExtent x h: viewportExtent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		useShaderResources: renderer resourceCache emptyLightingStateBinding bindingHandle;

		"Clear the depth buffer"
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: true writeMask: true function: AGPU_ALWAYS;
		setPrimitiveType: AGPU_TRIANGLES;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache clearReverseDepthFragmentShader entryPoint: 'main';
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;

		"Setup normal rendering"
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.
	isInDepthOnlyPass := true.

	self bindCameraState: convertedCameraState.
		
	shadowMapCameraLayer opaqueRenderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].

	stateTracker endRenderPass.
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> renderShadowMapFor: shadowMapCameraLayer atlasElement: atlasElement lightSource: lightSource [
	| convertedCameraState hasReverseDepth initialDepth shaderSignature viewportOffset viewportExtent |

	viewportOffset := atlasElement offset.
	viewportExtent := atlasElement extent.
		
	hasReverseDepth := shadowMapCameraLayer hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	shaderSignature := renderer resourceCache rendererShaderSignature.
	depthFunction := hasReverseDepth ifTrue: [ AGPU_GREATER_EQUAL ] ifFalse: [ AGPU_LESS_EQUAL ].

	convertedCameraState := self convertedCameraState: shadowMapCameraLayer cameraState framebufferExtent: viewportExtent.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.

	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache shadowMapRenderPass
			framebuffer: renderer resourceCache shadowMapAtlasFramebuffer bundle_content: 0;
		setViewport: viewportOffset x y: viewportOffset y w: viewportExtent x h: viewportExtent y;
		setScissor: viewportOffset x y: viewportOffset y w: viewportExtent x h: viewportExtent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		useShaderResources: renderer resourceCache emptyLightingStateBinding bindingHandle;

		"Clear the depth buffer"
		setCullMode: AGPU_CULL_MODE_NONE;
		setDepthState: true writeMask: true function: AGPU_ALWAYS;
		setDepthBias: lightSource shadowMapDepthBiasConstant asFloat negated clamp: 0.0 slope_factor: lightSource shadowMapDepthBiasSlope asFloat negated;
		setPrimitiveType: AGPU_TRIANGLES;
		setVertexStage: renderer resourceCache screenQuadVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache clearReverseDepthFragmentShader entryPoint: 'main';
		drawArrays: 3 instance_count: 1 first_vertex: 0 base_instance: 0;

		"Setup normal rendering"
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.
	isInDepthOnlyPass := true.

	self bindCameraState: convertedCameraState.
		
	shadowMapCameraLayer opaqueRenderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].

	stateTracker endRenderPass.
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrameRenderer >> renderer [

	^ renderer
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrameRenderer >> renderer: anObject [

	renderer := anObject
]

{ #category : #private }
WDAGPUSceneRendererActiveFrameRenderer >> resetCurrentActiveState [
	currentObjectVertexBinding := nil.
	currentObjectPrimitiveTopology := nil.
]

{ #category : #initialization }
WDAGPUSceneRendererActiveFrameRenderer >> setAlphaBlendingEnabled: enabled [
	alphaBlendingEnabled == enabled  ifTrue: [ ^ self ].
	enabled ifTrue: [
		stateTracker 
			setBlendState: -1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD
	] ifFalse: [ 
		stateTracker 
			setBlendState: -1 enabled: 0;
			setBlendFunction: 1
				sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ZERO colorOperation: AGPU_BLENDING_OPERATION_ADD
				sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_ZERO alphaOperation: AGPU_BLENDING_OPERATION_ADD
	].
	alphaBlendingEnabled := enabled
]

{ #category : #initialization }
WDAGPUSceneRendererActiveFrameRenderer >> setDepthTestingEnable: enabled writeMask: writeMask [
	(depthTestingEnabled == enabled and: [ depthWriteMask == writeMask ])ifTrue: [ ^ self ].
	stateTracker setDepthState: (enabled or: [writeMask])
		writeMask: writeMask
		function: (enabled ifTrue: [depthFunction] ifFalse: [AGPU_ALWAYS]).
	depthTestingEnabled := enabled.
	depthWriteMask := writeMask
]

{ #category : #private }
WDAGPUSceneRendererActiveFrameRenderer >> uploadLightStates: lights [
	| lightStateSize lightStateAlignment uploadAllocation destOffset |
	lightStateSize := WDAGPULightStateUniformBufferWriter uniqueInstance instanceSize.
	lightStateAlignment := WDAGPULightStateUniformBufferWriter uniqueInstance instanceAlignment.
	uploadAllocation := renderer resourceCache uploadBuffer allocate: (lights size + 1) * lightStateSize alignment: lightStateAlignment.
	
	destOffset := 0.
	lights doWithIndex: [ :light :index |
		| adjustedLight |
		adjustedLight := light copy.
		adjustedLight castShadows ifTrue: [ 
			adjustedLight shadowMapProjectionMatrices: (adjustedLight shadowMapProjectionMatrices collect: [:each | renderer resourceCache projectionNDCAdjustMatrix * each])
		].
	
		uploadAllocation writeValue: adjustedLight with: WDAGPULightStateUniformBufferWriter at: destOffset.
		destOffset := destOffset + lightStateSize
	].

	uploadAllocation writeValue: WDLightState empty with: WDAGPULightStateUniformBufferWriter at: destOffset.
	destOffset := destOffset + lightStateSize.
	
	stateTracker
		pushBufferTransitionBarrier: renderer resourceCache lightStateBuffer old_usage: AGPU_STORAGE_BUFFER new_usage: AGPU_COPY_DESTINATION_BUFFER;
		copyBuffer: uploadAllocation allocator buffer source_offset: uploadAllocation offset dest_buffer: renderer resourceCache lightStateBuffer dest_offset: 0 copy_size: destOffset;
		popBufferTransitionBarrier

]

{ #category : #handles }
WDAGPUSceneRendererActiveFrameRenderer >> validBufferHandleForAccessor: aWDBinaryBufferAccessor [
	^ activeResourceDictionary at: aWDBinaryBufferAccessor ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validBufferHandleForAccessor: aWDBinaryBufferAccessor.
		activeResources add: handle.
		handle
	]
]

{ #category : #handles }
WDAGPUSceneRendererActiveFrameRenderer >> validFramebufferFor: aWDFramebuffer [
	^ activeResourceDictionary at: aWDFramebuffer ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validFramebufferFor: aWDFramebuffer.
		activeResources add: handle.
		handle
	]
]

{ #category : #handles }
WDAGPUSceneRendererActiveFrameRenderer >> validIntermediateFramebuffersFor: aWDFramebuffer sampleCount: sampleCount initialDepth: initialDepth [
	^ activeResourceDictionary at: {#intermediateFramebuffer . aWDFramebuffer} ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validIntermediateFramebuffersFor: aWDFramebuffer sampleCount: sampleCount initialDepth: initialDepth.
		activeResources add: handle.
		handle
	]
]

{ #category : #handles }
WDAGPUSceneRendererActiveFrameRenderer >> validTextureViewHandleFor: aWDTexture fallbackTextureWith: aBlock [
	aWDTexture ifNil: [ 
		^ aBlock value getOrCreateFullView
	].

	^ (activeResourceDictionary at: aWDTexture ifAbsentPut: [
			| handle |
			handle := renderer resourceCache validTextureViewHandleFor: aWDTexture.
			activeResources add: handle.
			handle
		]) first
]

{ #category : #handles }
WDAGPUSceneRendererActiveFrameRenderer >> validVertexBindingFor: aWDVertexBufferBinding [
	aWDVertexBufferBinding ifNil: [ ^ nil ].
	^ activeResourceDictionary at: aWDVertexBufferBinding ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validVertexBindingFor: aWDVertexBufferBinding.
		activeResources add: handle.
		handle
	]
]
