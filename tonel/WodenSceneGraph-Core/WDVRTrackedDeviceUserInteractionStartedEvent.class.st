Class {
	#name : 'WDVRTrackedDeviceUserInteractionStartedEvent',
	#superclass : 'WDVRTrackedDeviceNotificationEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceUserInteractionStartedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUserInteractionStartedEvent: self
]
