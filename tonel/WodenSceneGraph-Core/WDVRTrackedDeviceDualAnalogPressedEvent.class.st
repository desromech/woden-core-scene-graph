Class {
	#name : #WDVRTrackedDeviceDualAnalogPressedEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogPressedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogPressedEvent: self
]
