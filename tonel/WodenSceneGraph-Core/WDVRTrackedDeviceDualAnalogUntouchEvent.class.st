Class {
	#name : 'WDVRTrackedDeviceDualAnalogUntouchEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogUntouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogUntouchEvent: self
]
