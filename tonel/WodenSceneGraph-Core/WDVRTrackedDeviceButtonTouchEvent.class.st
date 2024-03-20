Class {
	#name : #WDVRTrackedDeviceButtonTouchEvent,
	#superclass : #WDVRTrackedDeviceButtonEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceButtonTouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonTouchEvent: self
]
