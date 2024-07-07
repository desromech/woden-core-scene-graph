Class {
	#name : 'WDVRTrackedDeviceDualAnalogReleasedEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogReleasedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogReleasedEvent: self
]
