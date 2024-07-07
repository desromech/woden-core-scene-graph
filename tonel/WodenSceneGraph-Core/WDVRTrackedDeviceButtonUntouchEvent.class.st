Class {
	#name : 'WDVRTrackedDeviceButtonUntouchEvent',
	#superclass : 'WDVRTrackedDeviceButtonEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceButtonUntouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonUntouchEvent: self
]
