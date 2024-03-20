Class {
	#name : #WDVRTrackedDeviceNotificationEvent,
	#superclass : #WDVRTrackedDeviceEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #testing }
WDVRTrackedDeviceNotificationEvent class >> isAbstract [
	^ self == WDVRTrackedDeviceNotificationEvent
]
