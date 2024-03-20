"
I am an event handler for a specific VR tracked device.
"
Class {
	#name : #WDVRTrackedDeviceEventHandler,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #'event handling' }
WDVRTrackedDeviceEventHandler >> handleVREvent: vrEvent [
	^ vrEvent accept: self
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceActivatedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceButtonPressedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceButtonReleasedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceButtonTouchEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceButtonUntouchEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDeactivatedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogModeCancelEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogModeSwitch1Event: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogModeSwitch2Event: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogMoveEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogPressedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogReleasedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogTouchEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceDualAnalogUntouchEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceUpdatedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceUserInteractionEndedEvent: event [
]

{ #category : #'as yet unclassified' }
WDVRTrackedDeviceEventHandler >> onVRTrackedDeviceUserInteractionStartedEvent: event [
]
