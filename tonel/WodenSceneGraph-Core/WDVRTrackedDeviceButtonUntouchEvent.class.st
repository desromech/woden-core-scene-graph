Class {
	#name : #WDVRTrackedDeviceButtonUntouchEvent,
	#superclass : #WDVRTrackedDeviceButtonEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceButtonUntouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceButtonUntouchEvent: self
]
