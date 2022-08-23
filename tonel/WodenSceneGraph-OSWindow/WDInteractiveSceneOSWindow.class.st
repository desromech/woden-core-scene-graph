"
I am a Woden OSWindow with support for basic interactions.
"
Class {
	#name : #WDInteractiveSceneOSWindow,
	#superclass : #WDSceneOSWindow,
	#instVars : [
		'cameraAngles'
	],
	#category : #'WodenSceneGraph-OSWindow'
}

{ #category : #'as yet unclassified' }
WDInteractiveSceneOSWindow class >> eventHandlerClass [
	^ WDInteractiveSceneOSWindowEventHandler
]

{ #category : #'as yet unclassified' }
WDInteractiveSceneOSWindow >> computeCameraOrientation [
	^ (Quaternion yRotation: cameraAngles y) * (Quaternion xRotation: cameraAngles x)
]

{ #category : #initialization }
WDInteractiveSceneOSWindow >> initialize [
	super initialize.
	cameraAngles := Vector3 zeros.
]

{ #category : #events }
WDInteractiveSceneOSWindow >> onMouseMove: event [
	| delta |
	delta := event delta.
	renderMutex critical: [
		event buttons button1 ifTrue: [
			cameraAngles := cameraAngles + (Vector3 x: delta y negated degreesToRadians y: delta x negated degreesToRadians z: 0.0).
			camera orientation: self computeCameraOrientation.
			self changed.
		].
	
		event buttons button3 ifTrue: [
			camera translateBy: (camera orientation transformVector3: (Vector3 x: delta x y: delta y negated z: 0.0) * 0.01).
			self changed.
		].
	].

]

{ #category : #events }
WDInteractiveSceneOSWindow >> onMouseMoveEvent: event [
]

{ #category : #events }
WDInteractiveSceneOSWindow >> onMouseWheel: event [
	renderMutex critical: [
		camera translateBy: (camera orientation transformVector3: (Vector3 z: event scrollVertical) * -0.2).
		self changed
	]
]
