"
I am a Woden scene renderer that uses the agpu library.
"
Class {
	#name : #WDAGPUSceneRenderer,
	#superclass : #WDSceneRenderer,
	#instVars : [
		'device',
		'commandQueue',
		'stateTrackerCache',
		'stateTracker',
		'resourceCache',
		'activeResources'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU'
}

{ #category : #'instance creation' }
WDAGPUSceneRenderer class >> new [
	^ self withResourceCache: (WDAGPUSceneRendererResourceCache for: AGPU mainDevice)
]

{ #category : #'instance creation' }
WDAGPUSceneRenderer class >> withResourceCache: aResourceCache [
	^ self basicNew initializeWithResourceCache: aResourceCache; yourself
]

{ #category : #accessing }
WDAGPUSceneRenderer >> device [

	^ device
]

{ #category : #initialization }
WDAGPUSceneRenderer >> initializeWithResourceCache: aResourceCache [
	resourceCache := aResourceCache.
	device := resourceCache device.
	commandQueue := device getDefaultCommandQueue.
	stateTrackerCache := device createStateTrackerCache: commandQueue.
	stateTracker := stateTrackerCache createStateTracker: AGPU_COMMAND_LIST_TYPE_DIRECT command_queue: commandQueue.
]

{ #category : #rendering }
WDAGPUSceneRenderer >> readbackFramebufferAttachmentsOf: framebuffer [
	framebuffer colorAttachments do: [ :each |
		each usageMode isReadedColorAttachment ifTrue: [ 
			self readbackTextureData: each
		]
	].

	framebuffer depthStencilAttachment ifNotNil: [ :attachment |
		attachment usageMode isReadedColorAttachment ifTrue: [ 
			self readbackTextureData: attachment
		]
	]
]

{ #category : #rendering }
WDAGPUSceneRenderer >> readbackTextureData: texture [
	| form handle pitch |
	form := texture data.
	form isForm ifFalse: [ ^ self ].
	self assert: form depth = 32.
	
	handle := resourceCache validTextureHandleFor: texture.
	pitch := form width * 4.
	texture data unhibernate.
	handle readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: pitch * form height buffer: texture data bits.
]

{ #category : #rendering }
WDAGPUSceneRenderer >> recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer [
	| framebufferHandle |
	framebufferHandle := resourceCache validFramebufferFor: framebuffer.
	stateTracker
		beginRenderPass: resourceCache viewportOutputRenderPass framebuffer: framebufferHandle bundle_content: 0;
		setViewport: 0 y: 0 w: framebuffer width h: framebuffer height;
		setScissor: 0 y: 0 w: framebuffer width h: framebuffer height.
		
	stateTracker endRenderPass
]

{ #category : #rendering }
WDAGPUSceneRenderer >> renderSceneState: renderingSceneState intoFramebuffer: framebuffer [
	stateTracker beginRecordingCommands.
	activeResources := OrderedCollection new.
	[
		self recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer.
		
	] ensure: [
		stateTracker endRecordingAndFlushCommands.
		commandQueue finishExecution.
		activeResources := nil.
	].

	self readbackFramebufferAttachmentsOf: framebuffer
]

{ #category : #accessing }
WDAGPUSceneRenderer >> resourceCache [

	^ resourceCache
]
