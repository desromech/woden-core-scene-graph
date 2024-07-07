Class {
	#name : 'WDVRTrackedDeviceDualAnalogModeCancelEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogModeCancelEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogModeCancelEvent: self
]
