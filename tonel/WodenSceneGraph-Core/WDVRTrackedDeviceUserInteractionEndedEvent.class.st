Class {
	#name : #WDVRTrackedDeviceUserInteractionEndedEvent,
	#superclass : #WDVRTrackedDeviceNotificationEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceUserInteractionEndedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUserInteractionEndedEvent: self
]
