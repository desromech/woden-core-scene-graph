"
I represent a specific role for a tracked device.
"
Class {
	#name : #WDVRTrackedDeviceRole,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #converting }
WDVRTrackedDeviceRole class >> asVRTrackedDeviceRole [
	^ self uniqueInstance
]

{ #category : #converting }
WDVRTrackedDeviceRole >> asVRTrackedDeviceRole [
	^ self
]

{ #category : #testing }
WDVRTrackedDeviceRole >> isInvalid [
	^ false
]

{ #category : #testing }
WDVRTrackedDeviceRole >> isLeftHand [
	^ false
]

{ #category : #testing }
WDVRTrackedDeviceRole >> isOptOut [
	^ false
]

{ #category : #testing }
WDVRTrackedDeviceRole >> isRightHand [
	^ false
]

{ #category : #testing }
WDVRTrackedDeviceRole >> isThreadmill [
	^ false
]
