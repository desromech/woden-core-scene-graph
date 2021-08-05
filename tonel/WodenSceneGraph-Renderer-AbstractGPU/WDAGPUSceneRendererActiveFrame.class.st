Class {
	#name : #WDAGPUSceneRendererActiveFrame,
	#superclass : #Object,
	#instVars : [
		'renderer',
		'stateTracker',
		'activeResources',
		'activeSlabResource',
		'commandQueue',
		'activeResourceDictionary'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererActiveFrame >> abortRecording [
	self freeActiveResources.
	stateTracker := nil.
]

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererActiveFrame >> beginRecordingCommandsOn: aStateTracker queue: aCommandQueue [
	stateTracker := aStateTracker.
	commandQueue := aCommandQueue.
	activeResources := OrderedCollection new.
	activeSlabResource := OrderedCollection new.
	activeResourceDictionary := Dictionary new.
	stateTracker beginRecordingCommands. 
]

{ #category : #wrappers }
WDAGPUSceneRendererActiveFrame >> finishExecution [
	commandQueue finishExecution.
	self freeActiveResources.
]

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererActiveFrame >> freeActiveResources [
	activeSlabResource ifNotNil: [ 
		activeSlabResource do: [ :each | each free ].
		activeSlabResource := nil.
	].
	activeResources := nil.
	activeResourceDictionary := nil.

]

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererActiveFrame >> recordAndFlushCommandsOn: aStateTracker queue: aCommandQueue with: aBlock [
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
WDAGPUSceneRendererActiveFrame >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| framebufferHandle shaderSignature |
	framebufferHandle := self validFramebufferFor: framebuffer.
	shaderSignature := renderer resourceCache rendererShaderSignature.
	stateTracker
		beginRenderPass: renderer resourceCache viewportOutputRenderPass framebuffer: framebufferHandle bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height;
		setShaderSignature: shaderSignature handle;
		useShaderResources: shaderSignature samplersBinding.
		
	
		
	stateTracker endRenderPass
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrame >> renderer [

	^ renderer
]

{ #category : #accessing }
WDAGPUSceneRendererActiveFrame >> renderer: anObject [

	renderer := anObject
]

{ #category : #handles }
WDAGPUSceneRendererActiveFrame >> validFramebufferFor: aWDFramebuffer [
	^ activeResourceDictionary at: aWDFramebuffer ifAbsentPut: [
		| handle |
		handle := renderer resourceCache validFramebufferFor: aWDFramebuffer.
		activeResources add: handle.
		handle
	]
]
