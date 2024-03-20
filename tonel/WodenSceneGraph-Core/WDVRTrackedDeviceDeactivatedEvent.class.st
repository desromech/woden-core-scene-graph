Class {
	#name : #WDVRTrackedDeviceDeactivatedEvent,
	#superclass : #WDVRTrackedDeviceNotificationEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDeactivatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDeactivatedEvent: self
]
