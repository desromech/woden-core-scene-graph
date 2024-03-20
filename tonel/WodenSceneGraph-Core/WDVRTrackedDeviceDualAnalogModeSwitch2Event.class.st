Class {
	#name : #WDVRTrackedDeviceDualAnalogModeSwitch2Event,
	#superclass : #WDVRTrackedDeviceDualAnalogEvent,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #visiting }
WDVRTrackedDeviceDualAnalogModeSwitch2Event >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogModeSwitch2Event: self
]
