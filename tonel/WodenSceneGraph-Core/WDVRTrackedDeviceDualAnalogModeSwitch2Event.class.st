Class {
	#name : 'WDVRTrackedDeviceDualAnalogModeSwitch2Event',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogModeSwitch2Event >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogModeSwitch2Event: self
]
