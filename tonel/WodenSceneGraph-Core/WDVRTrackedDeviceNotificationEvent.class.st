Class {
	#name : 'WDVRTrackedDeviceNotificationEvent',
	#superclass : 'WDVRTrackedDeviceEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'testing' }
WDVRTrackedDeviceNotificationEvent class >> isAbstract [
	^ self == WDVRTrackedDeviceNotificationEvent
]
