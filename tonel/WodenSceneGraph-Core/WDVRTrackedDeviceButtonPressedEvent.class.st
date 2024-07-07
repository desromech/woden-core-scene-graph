Class {
	#name : 'WDVRTrackedDeviceButtonPressedEvent',
	#superclass : 'WDVRTrackedDeviceButtonEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceButtonPressedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonPressedEvent: self
]
