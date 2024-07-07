Class {
	#name : 'WDVRTrackedDeviceDualAnalogMoveEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogMoveEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogMoveEvent: self
]
