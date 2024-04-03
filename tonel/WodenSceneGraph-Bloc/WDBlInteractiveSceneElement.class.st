"
I am bloc element that can be used for displaying a Woden scene with some basic movement interactions.
"
Class {
	#name : #WDBlInteractiveSceneElement,
	#superclass : #WDBlSceneElement,
	#instVars : [
		'cameraAngles'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #'camera events' }
WDBlInteractiveSceneElement >> computeCameraOrientation [
	^ (Quaternion yRotation: cameraAngles y) * (Quaternion xRotation: cameraAngles x)
]

{ #category : #'camera events' }
WDBlInteractiveSceneElement >> dragCameraDelta: delta withEvent: dragEvent [
	camera ifNil: [ ^ self ].
	
	dragEvent button == BlMouseButton primary ifTrue: [
		cameraAngles := cameraAngles + (Vector3 x: delta y negated degreesToRadians y: delta x negated degreesToRadians z: 0.0).
		camera orientation: self computeCameraOrientation.
		self invalidate.
	].

	dragEvent button == BlMouseButton secondary ifTrue: [
		camera translateBy: (camera orientation transformVector3: (Vector3 x: delta x y: delta y negated z: 0.0) * 0.01).
		self invalidate.
	].
]

{ #category : #initialization }
WDBlInteractiveSceneElement >> initialize [
	super initialize.
	cameraAngles := Vector3 zeros.
	self addEventHandler: WDBlInteractiveSceneEventListener new.
	
]

{ #category : #'camera events' }
WDBlInteractiveSceneElement >> scrollCamera: scrollVector [
	| delta |
	camera ifNil: [ ^ self ].

	delta := Vector3 x: scrollVector x y: 0 z: scrollVector y negated.
	camera translateBy: (camera orientation transformVector3: delta * 0.2).
	self invalidate.
]
