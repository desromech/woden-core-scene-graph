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
		'activeResourceDictionary'
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
WDAGPUSceneRendererActiveFrameRenderer >> beginRecordingCommandsOn: aStateTracker queue: aCommandQueue [
	stateTracker := aStateTracker.
	commandQueue := aCommandQueue.
	activeResources := OrderedCollection new.
	activeSlabResource := OrderedCollection new.
	activeResourceDictionary := Dictionary new.
	stateTracker beginRecordingCommands. 
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> emitRenderingCommandsForMeshPrimitive: meshPrimitive [
	| vertexBindingHandle |
	vertexBindingHandle := self validVertexBindingFor: meshPrimitive vertexBinding.
	stateTracker
		setVertexLayout: vertexBindingHandle first;
		useVertexBinding: vertexBindingHandle second;
		setVertexStage: renderer resourceCache triangleVertexShader entryPoint: 'main';
		setFragmentStage: renderer resourceCache triangleFragmentShader entryPoint: 'main';
		setPrimitiveType: (PrimitiveTopologyMap at: meshPrimitive topology).
		
	meshPrimitive indices ifNil: [
		stateTracker
			drawArrays: meshPrimitive vertexBinding vertexCount instance_count: 1 first_vertex: 0 base_instance: 0
	] ifNotNil: [ :indicesAccessor |
		stateTracker
			useIndexBufferAt: (self validBufferHandleForAccessor: indicesAccessor)
				offset: indicesAccessor byteOffset + indicesAccessor bufferView byteOffset
				index_size: indicesAccessor componentType size;
			drawElements: indicesAccessor count instance_count: 1 first_index: 0 base_vertex: 0 base_instance: 0
	].

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
	self recordCommandsForRenderable: renderingObject renderable
]

{ #category : #rendering }
WDAGPUSceneRendererActiveFrameRenderer >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| framebufferHandle shaderSignature |
	framebufferHandle := self validFramebufferFor: framebuffer.
	shaderSignature := renderer resourceCache rendererShaderSignature.
	stateTracker
		beginRenderPass: renderer resourceCache viewportOutputRenderPass framebuffer: framebufferHandle bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding.
		
	renderingSceneState renderingObjects do: [ :each |
		self recordCommandsForRenderingObject: each
	].
	
		
	stateTracker endRenderPass
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrameRenderer >> renderer [

	^ renderer
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrameRenderer >> renderer: anObject [

	renderer := anObject
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
WDAGPUSceneRendererActiveFrameRenderer >> validVertexBindingFor: aWDVertexBufferBinding [
	^ activeResourceDictionary at: aWDVertexBufferBinding ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validVertexBindingFor: aWDVertexBufferBinding.
		activeResources add: handle.
		handle
	]
]
