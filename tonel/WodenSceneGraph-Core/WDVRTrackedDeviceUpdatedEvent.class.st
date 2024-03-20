Class {
	#name : #WDVRTrackedDeviceUpdatedEvent,
	#superclass : #WDVRTrackedDeviceNotificationEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceUpdatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUpdatedEvent: self
]
