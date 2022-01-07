"
I am a morph that displays a single woden scene with basic interactions.
"
Class {
	#name : #WDInteractiveSceneMorph,
	#superclass : #WDSceneMorph,
	#instVars : [
		'dragStartPosition',
		'cameraAngles'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #'as yet unclassified' }
WDInteractiveSceneMorph >> computeCameraOrientation [
	^ (Quaternion yRotation: cameraAngles y) * (Quaternion xRotation: cameraAngles x)
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> handlesMouseDown: anEvent [
	^ anEvent wasHandled not
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> handlesMouseMove: anEvent [
	^ anEvent wasHandled not 
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> handlesMouseWheel: anEvent [
	^ anEvent wasHandled not 
]

{ #category : #initialization }
WDInteractiveSceneMorph >> initialize [
	super initialize.
	cameraAngles := Vector3 zeros.
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> mouseDown: evt [
	camera ifNil: [ ^ self ].
	
	evt hand newKeyboardFocus: self.
	
	dragStartPosition := evt position.

	evt wasHandled: true.
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> mouseMove: evt [
	camera ifNil: [ ^ self ].
	
	evt hand newKeyboardFocus: self.
	
	evt redButtonPressed ifTrue: [
		| delta |
		delta := evt position - dragStartPosition.
		cameraAngles := cameraAngles + (Vector3 x: delta y negated degreesToRadians y: delta x negated degreesToRadians z: 0.0).

		camera orientation: self computeCameraOrientation.
		self changed.
	].

	evt yellowButtonPressed ifTrue: [ 
		| delta |
		delta := evt position - dragStartPosition.

		camera translateBy: (camera orientation transformVector3: (Vector3 x: delta x y: delta y negated z: 0.0) * 0.01).
		self changed.
	].

	dragStartPosition := evt position.
	
	evt wasHandled: true.
]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> mouseUp: evt [
	camera ifNil: [ ^ self ].

	evt wasHandled: true.

]

{ #category : #'event handling' }
WDInteractiveSceneMorph >> mouseWheel: evt [
	| delta |
	camera ifNil: [ ^ self ].

	delta := Vector3 zeros.
	
	evt isUp ifTrue: [ delta z: -1 ].
	evt isDown ifTrue: [ delta z: 1 ].

	camera translateBy: (camera orientation transformVector3: delta * 0.2).
	evt wasHandled: true.
	self changed.
]
