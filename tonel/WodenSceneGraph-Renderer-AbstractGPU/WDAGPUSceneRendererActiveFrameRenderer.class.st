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
		'isInDepthOnlyPass'
	],
	#classVars : [
		'PrimitiveTopologyMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #initialization }
WDAGPUSceneRendererActiveFrameRenderer class >> initialize [
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
WDAGPUSceneRendererActiveFrameRenderer >> allocateAndRenderShadowMapFor: shadowMapCameraLayer [
	| shadowCastingLightSource convertedCameraState hasReverseDepth initialDepth shaderSignature shadowMapExtent |

	shadowCastingLightSource := shadowMapCameraLayer shadowCastingLightSource.
	shadowCastingLightSource
		shadowMapViewportScale: (Vector2 x: 0.5 y: 0.5);
		shadowMapViewportOffset: (Vector2 x: 0.5 y: 0.5).
		
	renderer device hasTopLeftNdcOrigin = renderer device hasBottomLeftTextureCoordinates ifTrue: [ 
		shadowCastingLightSource shadowMapViewportScale y: shadowCastingLightSource shadowMapViewportScale y negated
	].
		
	hasReverseDepth := shadowMapCameraLayer hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	shaderSignature := renderer resourceCache rendererShaderSignature.
	depthFunction := hasReverseDepth ifTrue: [ AGPU_GREATER_EQUAL ] ifFalse: [ AGPU_LESS_EQUAL ].

	shadowMapExtent := renderer resourceCache shadowMapAtlasExtent.
	convertedCameraState := self convertedCameraState: shadowMapCameraLayer cameraState framebufferExtent: shadowMapExtent.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.

	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: renderer resourceCache shadowMapRenderPass
			framebuffer: renderer resourceCache shadowMapAtlasFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: shadowMapExtent x h: shadowMapExtent y;
		setScissor: 0 y: 0 w: shadowMapExtent x h: shadowMapExtent y;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		useShaderResources: renderer resourceCache emptyLightingStateBinding bindingHandle;
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.
	isInDepthOnlyPass := true.

	self bindCameraState: convertedCameraState.
		
	shadowMapCameraLayer renderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].

	stateTracker endRenderPass.
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
	material hasAlphaBlending ifTrue: [ ^ false ].
	locationMask := currentObjectVertexBinding locationMask bitAnd: renderer resourceCache depthOnlyVertexAttributesForMask.
	
	stateTracker
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask) entryPoint: 'main';
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
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: currentObjectVertexBinding locationMask) entryPoint: 'main';
		setFragmentStage: (material hasAlphaBlending
			ifTrue: [ renderer resourceCache duplicatedMetallicRoughnessLiquidTranslucentFragmentShader ]
			ifFalse: [renderer resourceCache duplicatedMetallicRoughnessLiquidOpaqueFragmentShader]) entryPoint: 'main';
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
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask) entryPoint: 'main';
		setFragmentStage: renderer resourceCache environmentMapOpaqueFragmentShader entryPoint: 'main';
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
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: currentObjectVertexBinding locationMask) entryPoint: 'main';
		setFragmentStage: (material hasAlphaBlending
			ifTrue: [ renderer resourceCache metallicRoughnessTranslucentFragmentShader ]
			ifFalse: [renderer resourceCache metallicRoughnessOpaqueFragmentShader]) entryPoint: 'main';
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
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: locationMask) entryPoint: 'main';
		setFragmentStage: (material hasAlphaBlending
			ifTrue: [ renderer resourceCache unlitTranslucentFragmentShader ]
			ifFalse: [renderer resourceCache unlitOpaqueFragmentShader]) entryPoint: 'main';
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
	^ renderingSceneState lightingStateInViewSpaceWithMaxNumberOfLights: WDAGPUSceneRenderer maxLightCapacity - 1
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
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderable: renderable [
	renderable emitRenderingCommandsWithRenderer: self
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordCommandsForRenderingObject: renderingObject [
	self bindObjectState: renderingObject objectState.
	self recordCommandsForRenderable: renderingObject renderable
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
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsFor: renderingSceneState cameraLayer: cameraLayer isFirst: isFirst intoFramebuffer: framebuffer intermediateFramebuffers: intermediateFramebuffers [
	| shaderSignature sampleCount hasReverseDepth initialDepth convertedCameraState convertedLightingState |
	sampleCount := renderingSceneState sampleCount.
	hasReverseDepth := renderingSceneState hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	shaderSignature := renderer resourceCache rendererShaderSignature.
	depthFunction := hasReverseDepth ifTrue: [ AGPU_GREATER_EQUAL ] ifFalse: [ AGPU_LESS_EQUAL ].

	convertedCameraState := self convertedCameraState: cameraLayer cameraState framebufferExtent: framebuffer extent.
	convertedLightingState := self makeLightingStateForRenderingSceneState: cameraLayer.
	
	convertedLightingState numberOfLights > 0 ifTrue: [ 
		self uploadLightStates: convertedLightingState lights.
	].

	stateTracker
		resetComputePipeline;
		setShaderSignature: shaderSignature handle.
	self
		bindComputeCameraState: convertedCameraState;
		bindComputeLightingState: convertedLightingState.
	self recordLightGridComputationCommands.
	
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: (renderer resourceCache hdrRenderPassWithSampleCount: sampleCount initialDepth: initialDepth keepBegin: isFirst not) framebuffer: intermediateFramebuffers hdrFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	depthWriteMask := true.
	alphaBlendingEnabled := false.
	isInDepthOnlyPass := false.

	self
		bindCameraState: convertedCameraState;
		bindLightingState: convertedLightingState.
		
	cameraLayer renderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].

	stateTracker endRenderPass.

]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| intermediateFramebuffers outputFramebufferHandle shaderSignature sampleCount hasReverseDepth initialDepth mainCameraState |
	sampleCount := renderingSceneState sampleCount.
	hasReverseDepth := renderingSceneState hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	intermediateFramebuffers := self validIntermediateFramebuffersFor: framebuffer
		sampleCount: sampleCount
		initialDepth: initialDepth.
	shaderSignature := renderer resourceCache rendererShaderSignature.
	
	renderingSceneState cameraLayers do: [ :cameraLayer |
		cameraLayer shadowMapCameraLayers do: [ :shadowMapCameraLayer |
			self allocateAndRenderShadowMapFor: shadowMapCameraLayer
		]
	].

	renderingSceneState cameraLayers doWithIndex: [ :cameraLayer :index |
		self recordRenderingCommandsFor: renderingSceneState cameraLayer: cameraLayer isFirst: index == 1 intoFramebuffer: framebuffer intermediateFramebuffers: intermediateFramebuffers
	].

	depthFunction := nil.
	depthTestingEnabled := nil.
	depthWriteMask := nil.
	alphaBlendingEnabled := nil.
	
	"For the exposure level."
	mainCameraState := (renderingSceneState mainCameraState ifNil: [WDCameraState new]) copy
		framebufferWidth: framebuffer width;
		framebufferHeight: framebuffer height;
		yourself.
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
			adjustedLight shadowMapProjectionMatrix: renderer resourceCache projectionNDCAdjustMatrix * adjustedLight shadowMapProjectionMatrix
		].
	
		uploadAllocation writeValue: adjustedLight with: WDAGPULightStateUniformBufferWriter at: destOffset.
		destOffset := destOffset + lightStateSize
	].

	uploadAllocation writeValue: WDLightState empty with: WDAGPULightStateUniformBufferWriter at: destOffset.
	
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
