"
I am a morph that displays a single Woden scene.
"
Class {
	#name : 'WDSceneMorph',
	#superclass : 'WDAbstractRenderingSceneStateMorph',
	#instVars : [
		'scene',
		'camera',
		'overlays'
	],
	#category : 'WodenSceneGraph-Morphic',
	#package : 'WodenSceneGraph-Morphic'
}

{ #category : 'as yet unclassified' }
WDSceneMorph >> buildWindowOverlaySceneGraphNodeWith: builder [
	overlays isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: (0@0 extent: self extent) build: [ 
		builder containerWith: (overlays collect: [:each | each buildFullSceneGraphWith: builder])
	]

]

{ #category : 'accessing' }
WDSceneMorph >> camera [

	^ camera
]

{ #category : 'accessing' }
WDSceneMorph >> camera: aCameraNode [
	camera := aCameraNode ifNotNil: [aCameraNode asSceneNode]
]

{ #category : 'event handling' }
WDSceneMorph >> handleMouseWheel: event [
	super handleMouseWheel: event.
	^ self eventHandler ifNotNil: [:handler | handler notifyMorphsOfEvent: event ofType: #mouseWheel from: self ]
]

{ #category : 'initialization' }
WDSceneMorph >> initialize [
	super initialize.
	overlays := #().
	self camera: WDCamera new.
]

{ #category : 'accessing' }
WDSceneMorph >> overlay: aWDWindowOverlay [
	aWDWindowOverlay ifNil: [ 
		self overlays: #()
	] ifNotNil: [ 
		self overlays: { aWDWindowOverlay }
	].

]

{ #category : 'accessing' }
WDSceneMorph >> overlays [
	^ overlays
]

{ #category : 'accessing' }
WDSceneMorph >> overlays: anArrayOfWDOverlay [
	overlays := anArrayOfWDOverlay.
	self changed
]

{ #category : 'accessing' }
WDSceneMorph >> renderingSceneState [
	| extent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	extent := self extent.
	aspectRatio := extent x asFloat / extent y.
	^ (camera asCameraStateWithAspectRatio: aspectRatio) ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : 'accessing' }
WDSceneMorph >> scene [

	^ scene
]

{ #category : 'accessing' }
WDSceneMorph >> scene: aWDScene [
	scene := aWDScene.
	scene ifNotNil: [ 
		self startStepping
	] ifNil: [ 
		self changed
	]

]

{ #category : 'stepping' }
WDSceneMorph >> step [
	scene ifNotNil: [ 
		(scene updateWithDeltaTime: self stepTime * 0.001) ifFalse: [
			self stopStepping
		].
		self changed
	].

]

{ #category : 'stepping' }
WDSceneMorph >> stepTime [
	^ 16
]
