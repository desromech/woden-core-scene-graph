Class {
	#name : 'WDVRTrackedDeviceUpdatedEvent',
	#superclass : 'WDVRTrackedDeviceNotificationEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceUpdatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUpdatedEvent: self
]
