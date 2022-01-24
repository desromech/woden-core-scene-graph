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
		'swapChainFramebuffer'
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

{ #category : #'initialize-release' }
WDAbstractRenderingSceneStateOSWindow >> close [
	renderMutex critical: [ 
		self doDestroySwapChain.
		device := nil.
		osWindow destroy.
		osWindow := nil.
	].
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
	
	self sceneRenderer
		renderSceneState: self renderingSceneState intoFramebuffer: swapChainFramebuffer.
	
	self swapBuffers
]

{ #category : #'updating screen' }
WDAbstractRenderingSceneStateOSWindow >> exposed [
	self render
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> initialize [
	super initialize.
	extent := self defaultExtent.
	isOutOfDate := true.
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
	osWindow show.
]

{ #category : #rendering }
WDAbstractRenderingSceneStateOSWindow >> render [
	osWindow ifNil: [ ^ self ].
	renderMutex critical: [ 
		self doRender.
	]
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindow >> renderingSceneState [
	^ nil
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
WDAbstractRenderingSceneStateOSWindow >> validateDevice [
	self sceneRenderer isAGPUSceneRenderer ifFalse: [ ^ false ].
	device := self sceneRenderer device.
	^ device isNotNil and: [ device isNull not ]
]

{ #category : #'scale factor' }
WDAbstractRenderingSceneStateOSWindow >> validateSwapChain [
	| oldSwapChain requiredExtent swapChainInfo platformSpecificHandle |
	requiredExtent := self windowExtent.
	(swapChain isNotNil and: [ swapChainExtent = requiredExtent and: [isOutOfDate not]]) ifTrue: [ ^ true ].
	
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

	^ swapChain isNotNil
]

{ #category : #initialization }
WDAbstractRenderingSceneStateOSWindow >> windowExtent [

	^ osWindow ifNil: [ 240@120 ] ifNotNil: [ osWindow extent ]
]
