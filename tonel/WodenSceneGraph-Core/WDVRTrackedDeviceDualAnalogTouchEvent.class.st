Class {
	#name : #WDVRTrackedDeviceDualAnalogTouchEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogTouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogTouchEvent: self
]
