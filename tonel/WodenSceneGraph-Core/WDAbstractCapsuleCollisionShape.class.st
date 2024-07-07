Class {
	#name : 'WDAbstractCapsuleCollisionShape',
	#superclass : 'WDConvexCollisionShape',
	#instVars : [
		'height',
		'radius',
		'halfHeight'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'construction' }
WDAbstractCapsuleCollisionShape class >> height: height radius: radius [
	^ self new height: height; radius: radius; yourself
]

{ #category : 'testing' }
WDAbstractCapsuleCollisionShape class >> isAbstract [
	^ self == WDAbstractCapsuleCollisionShape
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> computeLocalBoundingBox [
	self subclassResponsibility
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> halfHeight [
	^ halfHeight
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> height [

	^ height
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> height: aNumber [
	height := aNumber.
	halfHeight := aNumber / 2.
	self computeLocalBoundingBox.
]

{ #category : 'initialization' }
WDAbstractCapsuleCollisionShape >> initialize [
	super initialize.
	radius := 1.0.
	self height: 1.0.
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> radius [

	^ radius
]

{ #category : 'accessing' }
WDAbstractCapsuleCollisionShape >> radius: anObject [
	radius := anObject.
	self computeLocalBoundingBox.
]
