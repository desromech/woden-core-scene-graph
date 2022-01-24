Class {
	#name : #WDVRTrackedDevice,
	#superclass : #Object,
	#instVars : [
		'id',
		'currentPose',
		'currentRenderPose'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #accessing }
WDVRTrackedDevice >> currentPose [

	^ currentPose
]

{ #category : #accessing }
WDVRTrackedDevice >> currentPose: anObject [

	currentPose := anObject
]

{ #category : #accessing }
WDVRTrackedDevice >> currentRenderPose [

	^ currentRenderPose
]

{ #category : #accessing }
WDVRTrackedDevice >> currentRenderPose: anObject [

	currentRenderPose := anObject
]

{ #category : #accessing }
WDVRTrackedDevice >> id [

	^ id
]

{ #category : #accessing }
WDVRTrackedDevice >> id: anObject [

	id := anObject
]

{ #category : #initialization }
WDVRTrackedDevice >> initialize [
	super initialize.
	
	currentPose := WDVRTrackedDevicePose new.
	currentRenderPose := WDVRTrackedDevicePose new.
]

{ #category : #testing }
WDVRTrackedDevice >> isController [
	^ false
]

{ #category : #testing }
WDVRTrackedDevice >> isDisplayRedirect [
	^ false
]

{ #category : #testing }
WDVRTrackedDevice >> isGenericTracker [
	^ false
]

{ #category : #testing }
WDVRTrackedDevice >> isHeadMountedDisplay [
	^ false
]

{ #category : #testing }
WDVRTrackedDevice >> isInvalid [
	^ false
]

{ #category : #testing }
WDVRTrackedDevice >> isTrackingReference [
	^ false
]
