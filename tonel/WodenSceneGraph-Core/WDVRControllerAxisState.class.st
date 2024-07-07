Class {
	#name : 'WDVRControllerAxisState',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y'
	],
	#category : 'WodenSceneGraph-Core-VR',
	#package : 'WodenSceneGraph-Core',
	#tag : 'VR'
}

{ #category : 'testing' }
WDVRControllerAxisState >> isJoystick [
	^ false
]

{ #category : 'testing' }
WDVRControllerAxisState >> isTrackPad [
	^ false
]

{ #category : 'testing' }
WDVRControllerAxisState >> isTrigger [
	^ false
]

{ #category : 'accessing' }
WDVRControllerAxisState >> x [

	^ x
]

{ #category : 'accessing' }
WDVRControllerAxisState >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
WDVRControllerAxisState >> y [

	^ y
]

{ #category : 'accessing' }
WDVRControllerAxisState >> y: anObject [

	y := anObject
]
