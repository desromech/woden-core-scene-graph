"
I represent a specific tracked device pose.
"
Class {
	#name : #WDVRTrackedDevicePose,
	#superclass : #Object,
	#instVars : [
		'deviceToAbsoluteTransform',
		'linearVelocity',
		'angularVelocity'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #accessing }
WDVRTrackedDevicePose >> angularVelocity [

	^ angularVelocity
]

{ #category : #accessing }
WDVRTrackedDevicePose >> angularVelocity: anObject [

	angularVelocity := anObject
]

{ #category : #accessing }
WDVRTrackedDevicePose >> deviceToAbsoluteTransform [

	^ deviceToAbsoluteTransform
]

{ #category : #accessing }
WDVRTrackedDevicePose >> deviceToAbsoluteTransform: anObject [

	deviceToAbsoluteTransform := anObject
]

{ #category : #initialization }
WDVRTrackedDevicePose >> initialize [
	super initialize.
	
	deviceToAbsoluteTransform := ReversibleAffineTransform3D identity.
	linearVelocity := Vector3 zeros.
	angularVelocity := Vector3 zeros.
]

{ #category : #accessing }
WDVRTrackedDevicePose >> linearVelocity [

	^ linearVelocity
]

{ #category : #accessing }
WDVRTrackedDevicePose >> linearVelocity: anObject [

	linearVelocity := anObject
]
