Class {
	#name : #WDVRTrackedDeviceDualAnalogModeCancelEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogModeCancelEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogModeCancelEvent: self
]
