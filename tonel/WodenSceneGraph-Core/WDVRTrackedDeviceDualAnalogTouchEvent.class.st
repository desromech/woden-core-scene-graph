Class {
	#name : 'WDVRTrackedDeviceDualAnalogTouchEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogTouchEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogTouchEvent: self
]
