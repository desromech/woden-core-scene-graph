Class {
	#name : #WDVRTrackedDeviceDualAnalogEvent,
	#superclass : #WDVRTrackedDeviceEvent,
	#instVars : [
		'position',
		'transformedPosition',
		'which'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #testing }
WDVRTrackedDeviceDualAnalogEvent class >> isAbstract [
	^ self == WDVRTrackedDeviceDualAnalogEvent
]

{ #category : #initialization }
WDVRTrackedDeviceDualAnalogEvent >> initialize [
	super initialize.
	position := Vector2 zeros.
	transformedPosition := Vector2 zeros.
	which := 0.
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> position [

	^ position
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> position: anObject [

	position := anObject
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> transformedPosition [

	^ transformedPosition
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> transformedPosition: anObject [

	transformedPosition := anObject
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> which [

	^ which
]

{ #category : #accessing }
WDVRTrackedDeviceDualAnalogEvent >> which: anObject [

	which := anObject
]
