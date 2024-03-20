Class {
	#name : #WDVRTrackedDeviceDualAnalogUntouchEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogUntouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogUntouchEvent: self
]
