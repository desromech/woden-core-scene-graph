Class {
	#name : 'WDVRTrackedDeviceUserInteractionEndedEvent',
	#superclass : 'WDVRTrackedDeviceNotificationEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceUserInteractionEndedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceUserInteractionEndedEvent: self
]
