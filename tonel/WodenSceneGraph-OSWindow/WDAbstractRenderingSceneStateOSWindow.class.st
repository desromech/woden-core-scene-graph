"
I am generic OS Window wrapper for displaying an arbitrary woden rendering scene state.
"
Class {
	#name : #WDAbstractRenderingSceneStateOSWindow,
	#superclass : #Object,
	#instVars : [
		'renderMutex',
		'sceneRenderer',
		'osWindow',
		'swapChain',
		'swapChainExtent',
		'isOutOfDate',
		'device',
		'extent',
		'swapChainFramebuffer',
		'needsToRender',
		'renderingProcess',
		'vrEnabled',
		'leftEyeFramebuffer',
		'rightEyeFramebuffer',
		'leftEyeColorBuffer',
		'rightEyeColorBuffer',
		'stereoComposeMode',
		'vrSystem'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-OSWindow'
}

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow class >> eventHandlerClass [
	^ WDAbstractRenderingSceneStateOSWindowEventHandler
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> attempToCreateActualVRSystem [
	vrEnabled ifFalse: [
		vrSystem := WDDummyVRSystem new.
		^ self
	].

	vrSystem := self sceneRenderer createVRSystem.
	vrSystem ifNil: [ 
		vrSystem := WDDummyVRSystem new.
	].

]

{ #category : #updating }
WDAbstractRenderingSceneStateOSWindow >> changed [
	needsToRender := true.
]

{ #category : #'initialize-release' }
WDAbstractRenderingSceneStateOSWindow >> close [
	renderMutex critical: [ 
		self doDestroySwapChain.
		device := nil.
		osWindow destroy.
		osWindow := nil.
	].
	self terminateRenderProcess
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> closeRequest [
	self close
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> colorBufferFormat [
	^ AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> defaultExtent [
	^ 1024@576
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> displayExtent [
	swapChain ifNotNil: [ ^ swapChain getWidth @ swapChain getHeight ].
	^ extent
]

{ #category : #'initialize-release' }
WDAbstractRenderingSceneStateOSWindow >> doDestroySwapChain [
	device ifNotNil: [ device finishExecution ].
	swapChain ifNotNil: [ swapChain release. ].
	swapChain := nil.
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> doRender [
	self validateDevice ifFalse: [ ^ self ].
	self validateSwapChain ifFalse: [ ^ self ].

	self hasStereoRendering ifTrue: [
		self validateEyeFramebuffers ifFalse: [ ^ self ].
		self sceneRenderer
			renderLeftEyeSceneState: self leftEyeRenderingSceneState intoFramebuffer: leftEyeFramebuffer
			renderRightEyeSceneState: self rightEyeRenderingSceneState intoFramebuffer: rightEyeFramebuffer
			composeInto: swapChainFramebuffer mode: self stereoComposeMode.
			
		vrSystem ifNotNil: [ 
			vrSystem submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeColorBuffer
				rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeColorBuffer
		]
	] ifFalse: [ 
		self sceneRenderer
			renderSceneState: self renderingSceneState intoFramebuffer: swapChainFramebuffer.
	].
	
	self swapBuffers.
	needsToRender := false.
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> doUpdate [
]

{ #category : #'updating screen' }
WDAbstractRenderingSceneStateOSWindow >> exposed [
	self render
]

{ #category : #testing }
WDAbstractRenderingSceneStateOSWindow >> hasStereoRendering [
	^ vrEnabled
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> initialize [
	super initialize.
	extent := self defaultExtent.
	isOutOfDate := true.
	needsToRender := true.
	vrEnabled := false.
	self stereoComposeMode: WDSideBySideStereoCompositionMode.
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> isUsingRealVRSystem [
	^ vrSystem notNil and: [ vrSystem isRealVRSystem ]
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> leftEyeRenderingSceneState [
	^ self renderingSceneState
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> needsToRender [
	^ needsToRender or: [ self isUsingRealVRSystem ]
]

{ #category : #'instance creation' }
WDAbstractRenderingSceneStateOSWindow >> open [
	| eventHandler attributes |
	osWindow ifNotNil: [ ^ self ].
	
	renderMutex := Semaphore forMutualExclusion.
	eventHandler := self class eventHandlerClass new window: self.
	attributes := OSWindowAttributes new
		extent: extent;
		visible: false;
		yourself.
	osWindow := OSWindow createWithAttributes: attributes eventHandler: eventHandler.
	self attempToCreateActualVRSystem.
	osWindow show.
	self startRenderingProcess
]

{ #category : #rendering }
WDAbstractRenderingSceneStateOSWindow >> render [
	osWindow ifNil: [ ^ self ].
	renderMutex critical: [ 
		self doRender.
	]
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> renderingProcessEntry [
	| session |
	session := Smalltalk session.
	[ session == Smalltalk session and: [ osWindow notNil ] ] whileTrue: [ 
		self renderingProcessIteration
	]
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> renderingProcessIteration [
	self needsToRender ifTrue: [ 
		| renderStartTime renderEndTime renderDeltaTime timeToSleep |
		renderStartTime := Time microsecondClockValue.
		"self isUsingRealVRSystem" false ifTrue: [
			vrSystem beginFrameRenderingCycle
		].

		self updateAndRender.

		renderEndTime := Time microsecondClockValue.
		renderDeltaTime := renderEndTime - renderStartTime.
		timeToSleep := (16000 - renderDeltaTime) // 1000.
		false "self isUsingRealVRSystem" ifTrue: [
			vrSystem endFrameCycleWaiting: timeToSleep.
		] ifFalse: [ 
			timeToSleep > 0 ifTrue: [
				(Delay forMilliseconds: timeToSleep) wait
			]
		].
	] ifFalse: [ 
		(Delay forMilliseconds: 16) wait
	].
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> renderingProcessPriority [
	^ vrEnabled
		ifTrue: [ Processor userInterruptPriority ]
		ifFalse: [ Processor userSchedulingPriority ]
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> renderingSceneState [
	^ nil
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> requiredPerEyeExtent [
	^ vrSystem perEyeFrameBufferExtentForDisplayWithExtent: self displayExtent
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> rightEyeRenderingSceneState [
	^ self renderingSceneState
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> sceneRenderer [
	^ sceneRenderer ifNil: [ sceneRenderer := WDSceneRenderer newStandalone ]
]

{ #category : #asserting }
WDAbstractRenderingSceneStateOSWindow >> shouldUseVSync [
	^ AGPU shouldUseVSync
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> startRenderingProcess [
	self terminateRenderProcess.
	renderingProcess := [ self renderingProcessEntry ] forkAt: self renderingProcessPriority
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> stereoComposeMode [
	^ stereoComposeMode
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> stereoComposeMode: aStereoComposeMode [
	stereoComposeMode := aStereoComposeMode asStereoComposeMode.
	self changed
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> swapBuffers [
	[ 
		swapChain swapBuffers
	] on: AGPUError do: [ :ex |
		| errorCode |
		errorCode := ex errorCode.
		(errorCode = AGPU_OUT_OF_DATE or: [ errorCode = AGPU_SUBOPTIMAL ]) ifTrue: [
			errorCode = AGPU_OUT_OF_DATE ifTrue: [ isOutOfDate := true].
		] ifFalse: [ 
			ex signal
		]
	]
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> terminateRenderProcess [
	renderingProcess ifNotNil: [
		renderingProcess terminate.
		renderingProcess := nil.
	].
]

{ #category : #updating }
WDAbstractRenderingSceneStateOSWindow >> update [
	renderMutex critical: [ 
		self doUpdate
	]
]

{ #category : #rendering }
WDAbstractRenderingSceneStateOSWindow >> updateAndRender [
	renderMutex critical: [ 
		vrSystem ifNotNil: [ vrSystem pollEvents ].
		self doUpdate.

		self needsToRender ifTrue: [ 
			self doRender
		].
	
		vrSystem ifNotNil: [ vrSystem waitAndFetchPoses ]
	].
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> validateDevice [
	self sceneRenderer isAGPUSceneRenderer ifFalse: [ ^ false ].
	device := self sceneRenderer device.
	^ device notNil and: [ device isNull not ]
]

{ #category : #'as yet unclassified' }
WDAbstractRenderingSceneStateOSWindow >> validateEyeFramebuffers [
	| requiredExtent |
	requiredExtent := self requiredPerEyeExtent.
	(leftEyeFramebuffer isNil or: [ leftEyeFramebuffer extent ~= requiredExtent]) ifTrue: [ 
		leftEyeColorBuffer := WDTexture forSampledColorBufferWithExtent: requiredExtent.
		leftEyeFramebuffer := WDFramebuffer forColorAttachment: leftEyeColorBuffer.
	].
	(rightEyeFramebuffer isNil or: [ rightEyeFramebuffer extent ~= requiredExtent]) ifTrue: [ 
		rightEyeColorBuffer := WDTexture forSampledColorBufferWithExtent: requiredExtent.
		rightEyeFramebuffer := WDFramebuffer forColorAttachment: rightEyeColorBuffer.
	].
	^ true
]

{ #category : #'scale factor' }
WDAbstractRenderingSceneStateOSWindow >> validateSwapChain [
	| oldSwapChain requiredExtent swapChainInfo platformSpecificHandle |
	requiredExtent := self windowExtent.
	(swapChain notNil and: [ swapChainExtent = requiredExtent and: [isOutOfDate not]]) ifTrue: [ ^ true ].
	
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: 2;
		colorbuffer_format: self colorBufferFormat;
		width: requiredExtent x;
		height: requiredExtent y;
		flags: AGPU_SWAP_CHAIN_FLAG_APPLY_SCALE_FACTOR_FOR_HI_DPI;
		yourself.

	AGPU shouldUseVSync ifTrue: [ 
		swapChainInfo presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_FIFO
	] ifFalse: [ 
		swapChainInfo presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_MAILBOX.
		swapChainInfo fallback_presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_IMMEDIATE.
	].

	platformSpecificHandle := osWindow platformSpecificHandle.
	platformSpecificHandle window ifNotNil: [ :handle | swapChainInfo window: handle ].
	platformSpecificHandle surface ifNotNil: [ :handle | swapChainInfo surface: handle ].

	oldSwapChain := swapChain.
	oldSwapChain ifNotNil: [
		device finishExecution.
		swapChainInfo old_swap_chain: oldSwapChain handle
	].

	swapChain := device createSwapChain: device getDefaultCommandQueue swapChainInfo: swapChainInfo.
	swapChainExtent := requiredExtent.
	oldSwapChain ifNotNil: [ oldSwapChain release ].
	isOutOfDate := false.
	swapChainFramebuffer := WDFramebuffer forSwapChain: swapChain extent: swapChainExtent.

	^ swapChain notNil
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> vrEnabled [

	^ vrEnabled
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> vrEnabled: anObject [
	vrEnabled := anObject
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> vrSystem [
	^ vrSystem
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> windowExtent [

	^ osWindow ifNil: [ 240@120 ] ifNotNil: [ osWindow extent ]
]
