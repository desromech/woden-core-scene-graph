Class {
	#name : #WDVRTrackedDeviceDualAnalogReleasedEvent,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogReleasedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogReleasedEvent: self
]
