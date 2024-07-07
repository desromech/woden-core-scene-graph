Class {
	#name : 'WDVRTrackedDeviceButtonReleasedEvent',
	#superclass : 'WDVRTrackedDeviceButtonEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceButtonReleasedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonReleasedEvent: self
]
