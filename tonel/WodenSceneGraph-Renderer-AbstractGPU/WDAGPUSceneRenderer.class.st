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
		'resourceCache'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #testing }
WDAGPUSceneRenderer class >> isAvailable [
	^ true
]

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

{ #category : #testing }
WDAGPUSceneRenderer >> isAGPUSceneRenderer [
	^ true
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
WDAGPUSceneRenderer >> renderLeftEyeSceneState: leftEyeRenderingSceneState intoFramebuffer: leftEyeFramebuffer
renderRightEyeSceneState: rightEyeRenderingSceneState intoFramebuffer: rightEyeFramebuffer
composeInto: destinationFramebuffer mode: composeMode [
	WDAGPUSceneRendererActiveFrameRenderer new
		renderer: self;
		recordAndFlushCommandsOn: stateTracker queue: commandQueue with: [ :frame |
			frame
				recordRenderingCommandsFor: leftEyeRenderingSceneState intoFramebuffer: leftEyeFramebuffer;
				recordRenderingCommandsFor: rightEyeRenderingSceneState intoFramebuffer: rightEyeFramebuffer;
				composeStereoLeft: leftEyeFramebuffer right: rightEyeFramebuffer into: destinationFramebuffer mode: composeMode
		];
		finishExecution.
	self readbackFramebufferAttachmentsOf: destinationFramebuffer
]

{ #category : #rendering }
WDAGPUSceneRenderer >> renderSceneState: renderingSceneState intoFramebuffer: framebuffer [
	WDAGPUSceneRendererActiveFrameRenderer new
		renderer: self;
		recordAndFlushCommandsOn: stateTracker queue: commandQueue with: [ :frame |
			frame recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer.
		];
		finishExecution.
	self readbackFramebufferAttachmentsOf: framebuffer
]

{ #category : #accessing }
WDAGPUSceneRenderer >> resourceCache [

	^ resourceCache
]
