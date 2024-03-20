"
I represent a specific virtual reality system.
"
Class {
	#name : #WDVRSystem,
	#superclass : #Object,
	#instVars : [
		'yieldSemaphore',
		'hasRenderedInThisFrame',
		'vrFrameCount'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #testing }
WDVRSystem >> beginFrameRenderingCycle [
	hasRenderedInThisFrame := false.
]

{ #category : #testing }
WDVRSystem >> endFrameCycleWaiting: timeToSleep [
	(self isInStandbyMode and: [timeToSleep > 0]) ifTrue: [
		^ (Delay forMilliseconds: timeToSleep) wait
	].

	hasRenderedInThisFrame ifTrue: [
		(vrFrameCount isNil or: [ vrFrameCount = 0 ]) ifTrue: [ 
			vrFrameCount := 5.
			self yield
		] ifFalse: [ 
			vrFrameCount := vrFrameCount - 1
		].
	] ifFalse: [ 
		timeToSleep > 0 ifTrue: [
			(Delay forMilliseconds: timeToSleep) wait
		]
	].
]

{ #category : #head }
WDVRSystem >> headTransform [
	^ ReversibleAffineTransform3D identity 
]

{ #category : #testing }
WDVRSystem >> initialize [
	super initialize.
	yieldSemaphore := Semaphore new.
]

{ #category : #testing }
WDVRSystem >> isDummyVRSystem [
	^ false
]

{ #category : #testing }
WDVRSystem >> isInStandbyMode [
	^ false
]

{ #category : #testing }
WDVRSystem >> isRealVRSystem [
	^ false
]

{ #category : #eyes }
WDVRSystem >> leftEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> leftEyeLocalTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'as yet unclassified' }
WDVRSystem >> leftEyeTransform [
	^ self headTransform transformTransform: self leftEyeLocalTransform
]

{ #category : #'as yet unclassified' }
WDVRSystem >> perEyeFrameBufferExtentForDisplayWithExtent: displayExtent [
	^ displayExtent
]

{ #category : #'vr system' }
WDVRSystem >> pollEvents [
]

{ #category : #initialization }
WDVRSystem >> resetTrackedDeviceEventHandlers [
	self trackedDevicesDo: [ :each | each resetEventHandler ]
]

{ #category : #eyes }
WDVRSystem >> rightEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> rightEyeLocalTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'as yet unclassified' }
WDVRSystem >> rightEyeTransform [
	^ self headTransform transformTransform: self rightEyeLocalTransform
]

{ #category : #'vr system' }
WDVRSystem >> submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeTexture rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeTexture [
	hasRenderedInThisFrame := true.
]

{ #category : #accessing }
WDVRSystem >> trackedDevicesDo: aBlock [
	^ #()
]

{ #category : #'vr system' }
WDVRSystem >> waitAndFetchPoses [
]

{ #category : #testing }
WDVRSystem >> yield [
	[ yieldSemaphore signal ] forkAt: Processor lowestPriority.
	yieldSemaphore wait; consumeAllSignals
]
