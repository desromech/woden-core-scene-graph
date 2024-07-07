"
I am an event from a tracked VR device.
"
Class {
	#name : 'WDVRTrackedDeviceEvent',
	#superclass : 'Object',
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'testing' }
WDVRTrackedDeviceEvent class >> isAbstract [
	^ self == WDVRTrackedDeviceEvent
]

{ #category : 'visiting' }
WDVRTrackedDeviceEvent >> accept: eventHandler [
	self subclassResponsibility
]
