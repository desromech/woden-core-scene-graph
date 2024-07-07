Class {
	#name : 'WDVRTrackedDeviceButtonTouchEvent',
	#superclass : 'WDVRTrackedDeviceButtonEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceButtonTouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonTouchEvent: self
]
