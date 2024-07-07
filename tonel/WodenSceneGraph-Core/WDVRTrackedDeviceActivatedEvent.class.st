Class {
	#name : 'WDVRTrackedDeviceActivatedEvent',
	#superclass : 'WDVRTrackedDeviceNotificationEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceActivatedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceActivatedEvent: self
]
