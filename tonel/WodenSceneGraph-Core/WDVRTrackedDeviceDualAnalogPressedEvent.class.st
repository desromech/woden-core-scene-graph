Class {
	#name : 'WDVRTrackedDeviceDualAnalogPressedEvent',
	#superclass : 'WDVRTrackedDeviceDualAnalogEvent',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'visiting' }
WDVRTrackedDeviceDualAnalogPressedEvent >> accept: eventHandler [
	^ eventHandler onVRTrackedDeviceDualAnalogPressedEvent: self
]
