Class {
	#name : #WDVRTrackedDeviceDualAnalogModeSwitch1Event,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogModeSwitch1Event >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogModeSwitch1Event: self
]
