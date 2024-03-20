Class {
	#name : #WDVRTrackedDeviceButtonReleasedEvent,
	#superclass : #WDVRTrackedDeviceButtonEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceButtonReleasedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonReleasedEvent: self
]
