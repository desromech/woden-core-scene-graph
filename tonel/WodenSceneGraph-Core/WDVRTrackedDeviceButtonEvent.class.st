Class {
	#name : 'WDVRTrackedDeviceButtonEvent',
	#superclass : 'WDVRTrackedDeviceEvent',
	#instVars : [
		'button'
	],
	#classVars : [
		'TrackedDeviceAxis0',
		'TrackedDeviceAxis1',
		'TrackedDeviceAxis2',
		'TrackedDeviceAxis3',
		'TrackedDeviceAxis4',
		'TrackedDeviceButtonA',
		'TrackedDeviceButtonApplicationMenu',
		'TrackedDeviceButtonDPadDown',
		'TrackedDeviceButtonDPadLeft',
		'TrackedDeviceButtonDPadRight',
		'TrackedDeviceButtonDPadUp',
		'TrackedDeviceButtonGrip',
		'TrackedDeviceButtonSystem',
		'TrackedDeviceProximitySensor'
	],
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'class initialization' }
WDVRTrackedDeviceButtonEvent class >> initialize [
	TrackedDeviceButtonSystem := 0.
	TrackedDeviceButtonApplicationMenu := 1.
	TrackedDeviceButtonGrip := 2.
	TrackedDeviceButtonDPadLeft := 3.
	TrackedDeviceButtonDPadUp := 4.
	TrackedDeviceButtonDPadRight := 5.
	TrackedDeviceButtonDPadDown := 6.
	TrackedDeviceButtonA := 7.
	
	TrackedDeviceProximitySensor := 31.
	TrackedDeviceAxis0 := 32.
	TrackedDeviceAxis1 := 33.
	TrackedDeviceAxis2 := 34.
	TrackedDeviceAxis3 := 35.
	TrackedDeviceAxis4 := 36.

]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent class >> isAbstract [
	^ self == WDVRTrackedDeviceButtonEvent
]

{ #category : 'accessing' }
WDVRTrackedDeviceButtonEvent >> button [

	^ button
]

{ #category : 'accessing' }
WDVRTrackedDeviceButtonEvent >> button: anObject [

	button := anObject
]

{ #category : 'initialization' }
WDVRTrackedDeviceButtonEvent >> initialize [
	super initialize.
	button := 0.
	
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isAxis0 [
	^ button = TrackedDeviceAxis0
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isAxis1 [
	^ button = TrackedDeviceAxis1
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isAxis2 [
	^ button = TrackedDeviceAxis2
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isAxis3 [
	^ button = TrackedDeviceAxis3
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isAxis4 [
	^ button = TrackedDeviceAxis4
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonA [
	^ button = TrackedDeviceButtonA
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonApplicationMenu [
	^ button = TrackedDeviceButtonApplicationMenu
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonAxis0 [
	^ button = TrackedDeviceProximitySensor
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonDPadDown [
	^ button = TrackedDeviceButtonDPadDown
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonDPadLeft [
	^ button = TrackedDeviceButtonDPadLeft
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonDPadRight [
	^ button = TrackedDeviceButtonDPadRight
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonDPadUp [
	^ button = TrackedDeviceButtonDPadUp
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonGrip [
	^ button = TrackedDeviceButtonGrip
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isButtonSystem [
	^ button = TrackedDeviceButtonSystem
]

{ #category : 'testing' }
WDVRTrackedDeviceButtonEvent >> isProximitySensor [
	^ button = TrackedDeviceProximitySensor
]
