Class {
	#name : #WDVRTrackedDeviceButtonPressedEvent,
	#superclass : #WDVRTrackedDeviceButtonEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceButtonPressedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonPressedEvent: self
]
