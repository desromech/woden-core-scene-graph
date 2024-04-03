"
I am a Bloc element that can display a Woden scene from the point of view of a specific camera.
"
Class {
	#name : #WDBlSceneElement,
	#superclass : #WDBlAbstractRenderingSceneStateElement,
	#instVars : [
		'scene',
		'camera'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #accessing }
WDBlSceneElement >> camera [

	^ camera
]

{ #category : #accessing }
WDBlSceneElement >> camera: aCameraNode [
	camera := aCameraNode ifNotNil: [aCameraNode asSceneNode]
]

{ #category : #initialization }
WDBlSceneElement >> initialize [
	super initialize.
	self camera: WDCamera new.
]

{ #category : #accessing }
WDBlSceneElement >> renderingSceneState [
	| extent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	extent := self size.
	aspectRatio := extent x asFloat / extent y.
	^ (camera asCameraStateWithAspectRatio: aspectRatio) ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : #accessing }
WDBlSceneElement >> scene [

	^ scene
]

{ #category : #accessing }
WDBlSceneElement >> scene: aNewScene [
	scene := aNewScene.
	self invalidate.
]
