Class {
	#name : 'WDVRTrackedDeviceDeactivatedEvent',
	#superclass : 'WDVRTrackedDeviceNotificationEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDeactivatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDeactivatedEvent: self
]
