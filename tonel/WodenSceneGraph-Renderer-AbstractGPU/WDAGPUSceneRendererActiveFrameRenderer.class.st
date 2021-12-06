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
		'depthTestingEnabled'
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
	
	self setDepthTestingEnable: material hasDepthTesting.
	
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
	stateTracker useShaderResources: (activeResourceDictionary at: cameraState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateCameraState.
		binding writeState: cameraState with: WDAGPUCameraStateUniformBufferWriter.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

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
WDAGPUSceneRendererActiveFrameRenderer >> bindLightingState: lightingState [
	stateTracker useShaderResources: (activeResourceDictionary at: lightingState ifAbsentPut: [ 
		| binding |
		binding := renderer resourceCache rendererShaderSignature allocateLightingState.
		binding
			writeState: lightingState with: WDAGPULightingStateUniformBufferWriter;
			bindSampledTextureView: renderer resourceCache brdfLutTexture getOrCreateFullView inSlot: 1;
			bindSampledTextureView: (self validTextureViewHandleFor: lightingState ambientDiffuseLightProbeTexture fallbackTextureWith: [renderer resourceCache transparentTextureCube ]) inSlot: 2;
			bindSampledTextureView: (self validTextureViewHandleFor: lightingState ambientSpecularLightProbeTexture fallbackTextureWith: [renderer resourceCache transparentTextureCube ]) inSlot: 3.
		activeSlabResource add: binding.
		binding
	]) bindingHandle.

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
WDAGPUSceneRendererActiveFrameRenderer >> convertedCameraState: aCameraState [
	^ aCameraState shallowCopy
		projectionMatrix: renderer resourceCache projectionNDCAdjustMatrix * aCameraState projectionMatrix;
		yourself
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> emitEnvironmentMapMaterialActivationCommands: material [
	| locationMask |
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
		setFragmentStage: renderer resourceCache forwardEnvironmentMapFragmentShader entryPoint: 'main';
		setCullMode: (material doubleSided
			ifTrue: [ AGPU_CULL_MODE_NONE ]
			ifFalse: [ AGPU_CULL_MODE_BACK ]).
	^ true
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> emitMetallicRoughnessMaterialActivationCommands: material [
	| locationMask |
	locationMask := currentObjectVertexBinding locationMask.
	
	stateTracker
		useShaderResources: (activeResourceDictionary at: material ifAbsentPut: [ 
			| binding |
			binding := renderer resourceCache rendererShaderSignature allocateMaterialState.
			binding
				writeState: material with: WDAGPUMetallicRoughnessMaterialUniformBufferWriter;
				bindSampledTextureView: (self validTextureViewHandleFor: material baseColorTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 1;
				bindSampledTextureView: (self validTextureViewHandleFor: material emissiveTexture fallbackTextureWith: [renderer resourceCache transparentTexture2D]) inSlot: 2;
				bindSampledTextureView: (self validTextureViewHandleFor: material normalTexture fallbackTextureWith: [renderer resourceCache neutralNormalTexture]) inSlot: 3;
				bindSampledTextureView: (self validTextureViewHandleFor: material occlusionTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 4;
				bindSampledTextureView: (self validTextureViewHandleFor: material metallicRoughnessTexture fallbackTextureWith: [renderer resourceCache whiteTexture2D]) inSlot: 5.
			activeSlabResource add: binding.
			binding
		]) bindingHandle;
		setVertexStage: (renderer resourceCache genericSurfaceMaterialVertexShaderWithLocationMask: currentObjectVertexBinding locationMask) entryPoint: 'main';
		setFragmentStage: renderer resourceCache forwardMetallicRoughnessFragmentShader entryPoint: 'main';
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

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> emitUnlitMaterialActivationCommands: material [
	| locationMask |
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
		setFragmentStage: renderer resourceCache forwardUnlitFragmentShader entryPoint: 'main';
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
	self resetCurrentActiveState
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> makeLightingStateForRenderingSceneState: renderingSceneState [
	^ renderingSceneState lightingStateInViewSpaceWithMaxNumberOfLights: 8
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
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| intermediateFramebuffers outputFramebufferHandle shaderSignature sampleCount hasReverseDepth initialDepth mainCameraState |
	sampleCount := renderingSceneState sampleCount.
	hasReverseDepth := renderingSceneState hasReverseDepth.
	initialDepth := hasReverseDepth ifTrue: [0.0] ifFalse: [1.0].
	intermediateFramebuffers := self validIntermediateFramebuffersFor: framebuffer
		sampleCount: sampleCount
		initialDepth: initialDepth.
	depthFunction := hasReverseDepth ifTrue: [AGPU_GREATER_EQUAL] ifFalse: [ AGPU_LESS_EQUAL ].
	
	shaderSignature := renderer resourceCache rendererShaderSignature.
	stateTracker
		resetGraphicsPipeline;
		beginRenderPass: (renderer resourceCache hdrRenderPassWithSampleCount: sampleCount initialDepth: initialDepth) framebuffer: intermediateFramebuffers hdrFramebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding;
		setFrontFace: AGPU_COUNTER_CLOCKWISE;
		setDepthState: true writeMask: true function: depthFunction.

	depthTestingEnabled := true.
	renderingSceneState cameraLayers do: [ :each |
		self recordRenderingCommandsForCameraLayer: each
	].
		
	stateTracker endRenderPass.
	depthTestingEnabled := nil.
	
	"For the exposure level."
	mainCameraState := renderingSceneState mainCameraState ifNil: [WDCameraState new].
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
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsForCameraLayer: cameraLayerState [
	self
		bindCameraState: (self convertedCameraState: cameraLayerState cameraState);
		bindLightingState: (self makeLightingStateForRenderingSceneState: cameraLayerState).
		
	cameraLayerState renderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].
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
WDAGPUSceneRendererActiveFrameRenderer >> setDepthTestingEnable: enabled [
	depthTestingEnabled == enabled ifTrue: [ ^ self ].
	stateTracker setDepthState: enabled writeMask: enabled function: depthFunction.
	depthTestingEnabled := enabled.
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
WDAGPUSceneRendererActiveFrameRenderer >> validIntermediateFramebuffersFor: aWDFramebuffer [
	^ activeResourceDictionary at: {#intermediateFramebuffer . aWDFramebuffer} ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validIntermediateFramebuffersFor: aWDFramebuffer.
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
