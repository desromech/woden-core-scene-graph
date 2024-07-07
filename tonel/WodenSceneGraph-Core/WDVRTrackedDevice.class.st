Class {
	#name : 'WDVRTrackedDevice',
	#superclass : 'Object',
	#instVars : [
		'id',
		'currentPose',
		'currentRenderPose',
		'role',
		'eventHandler',
		'renderModel',
		'controllerState'
	],
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'accessing' }
WDVRTrackedDevice >> controllerState [

	^ controllerState
]

{ #category : 'accessing' }
WDVRTrackedDevice >> controllerState: anObject [

	controllerState := anObject
]

{ #category : 'accessing' }
WDVRTrackedDevice >> currentPose [

	^ currentPose
]

{ #category : 'accessing' }
WDVRTrackedDevice >> currentPose: anObject [

	currentPose := anObject
]

{ #category : 'accessing' }
WDVRTrackedDevice >> currentRenderPose [

	^ currentRenderPose
]

{ #category : 'accessing' }
WDVRTrackedDevice >> currentRenderPose: anObject [

	currentRenderPose := anObject
]

{ #category : 'accessing' }
WDVRTrackedDevice >> eventHandler [

	^ eventHandler
]

{ #category : 'accessing' }
WDVRTrackedDevice >> eventHandler: anObject [

	eventHandler := anObject
]

{ #category : 'accessing' }
WDVRTrackedDevice >> id [

	^ id
]

{ #category : 'accessing' }
WDVRTrackedDevice >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
WDVRTrackedDevice >> initialize [
	super initialize.
	
	currentPose := WDVRTrackedDevicePose new.
	currentRenderPose := WDVRTrackedDevicePose new.
	self role: WDVRTrackedDeviceRoleInvalid.
]

{ #category : 'testing' }
WDVRTrackedDevice >> isController [
	^ false
]

{ #category : 'testing' }
WDVRTrackedDevice >> isDisplayRedirect [
	^ false
]

{ #category : 'testing' }
WDVRTrackedDevice >> isGenericTracker [
	^ false
]

{ #category : 'testing' }
WDVRTrackedDevice >> isHeadMountedDisplay [
	^ false
]

{ #category : 'testing' }
WDVRTrackedDevice >> isInvalid [
	^ false
]

{ #category : 'testing' }
WDVRTrackedDevice >> isTrackingReference [
	^ false
]

{ #category : 'as yet unclassified' }
WDVRTrackedDevice >> processAndDispatchEvent: vrEvent [
	eventHandler ifNotNil: [eventHandler handleVREvent: vrEvent]
]

{ #category : 'accessing' }
WDVRTrackedDevice >> renderModel [

	^ renderModel
]

{ #category : 'accessing' }
WDVRTrackedDevice >> renderModel: anObject [

	renderModel := anObject
]

{ #category : 'initialization' }
WDVRTrackedDevice >> resetEventHandler [
	eventHandler := nil.
]

{ #category : 'accessing' }
WDVRTrackedDevice >> role [

	^ role
]

{ #category : 'accessing' }
WDVRTrackedDevice >> role: aRole [
	role := aRole asVRTrackedDeviceRole
]
