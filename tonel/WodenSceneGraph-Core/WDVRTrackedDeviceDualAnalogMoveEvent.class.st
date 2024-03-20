Class {
	#name : #WDVRTrackedDeviceDualAnalogMoveEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogMoveEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogMoveEvent: self
]
