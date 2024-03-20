Class {
	#name : #WDVRTrackedDeviceActivatedEvent,
	#superclass : #WDVRTrackedDeviceNotificationEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceActivatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceActivatedEvent: self
]
