Class {
	#name : #WDVRTrackedDeviceUserInteractionStartedEvent,
	#superclass : #WDVRTrackedDeviceNotificationEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceUserInteractionStartedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUserInteractionStartedEvent: self
]
