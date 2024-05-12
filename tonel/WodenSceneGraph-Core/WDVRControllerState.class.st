Class {
	#name : #WDVRControllerState,
	#superclass : #Object,
	#instVars : [
		'touchedButtons',
		'pressedButtons',
		'axes',
		'joysticks',
		'trackpads',
		'triggers'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #accessing }
WDVRControllerState >> axes [
	^ axes
]

{ #category : #accessing }
WDVRControllerState >> axes: aListOfAxes [
	axes := aListOfAxes.
	joysticks := aListOfAxes select: [:each | each isJoystick ].
	trackpads := aListOfAxes select: [:each | each isTrackPad ].
	triggers := aListOfAxes select: [:each | each isTrigger ].
]

{ #category : #initialization }
WDVRControllerState >> initialize [
	super initialize.
	axes := #().
	joysticks := #().
	trackpads := #().
	triggers := #().
]

{ #category : #accessing }
WDVRControllerState >> joysticks [

	^ joysticks
]

{ #category : #accessing }
WDVRControllerState >> pressedButtons [

	^ pressedButtons
]

{ #category : #accessing }
WDVRControllerState >> pressedButtons: anObject [

	pressedButtons := anObject
]

{ #category : #accessing }
WDVRControllerState >> touchedButtons [

	^ touchedButtons
]

{ #category : #accessing }
WDVRControllerState >> touchedButtons: anObject [

	touchedButtons := anObject
]

{ #category : #accessing }
WDVRControllerState >> trackpads [

	^ trackpads
]

{ #category : #accessing }
WDVRControllerState >> triggers [

	^ triggers
]
