"
I am a morph that displays a single Woden scene.
"
Class {
	#name : #WDSceneMorph,
	#superclass : #WDAbstractRenderingSceneStateMorph,
	#instVars : [
		'scene',
		'camera'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #accessing }
WDSceneMorph >> camera [

	^ camera
]

{ #category : #accessing }
WDSceneMorph >> camera: aCameraNode [
	camera := aCameraNode ifNotNil: [aCameraNode asSceneNode]
]

{ #category : #'event handling' }
WDSceneMorph >> handleMouseWheel: event [
	super handleMouseWheel: event.
	^ self eventHandler ifNotNil: [:handler | handler notifyMorphsOfEvent: event ofType: #mouseWheel from: self ]
]

{ #category : #initialization }
WDSceneMorph >> initialize [
	super initialize.
	self camera: WDCamera new.
]

{ #category : #accessing }
WDSceneMorph >> renderingSceneState [
	| extent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	extent := self extent.
	aspectRatio := extent x asFloat / extent y.
	^ (camera asCameraStateWithAspectRatio: aspectRatio) ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : #accessing }
WDSceneMorph >> scene [

	^ scene
]

{ #category : #accessing }
WDSceneMorph >> scene: aWDScene [
	scene := aWDScene.
	self changed
]
