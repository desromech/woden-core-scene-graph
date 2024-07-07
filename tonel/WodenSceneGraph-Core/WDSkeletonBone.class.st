"
I am a bone specified in a skeleton
"
Class {
	#name : 'WDSkeletonBone',
	#superclass : 'Object',
	#instVars : [
		'name',
		'transform',
		'parentIndex',
		'index',
		'baseGlobalTransform'
	],
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'accessing' }
WDSkeletonBone >> baseGlobalTransform [

	^ baseGlobalTransform
]

{ #category : 'accessing' }
WDSkeletonBone >> baseGlobalTransform: anObject [

	baseGlobalTransform := anObject
]

{ #category : 'accessing' }
WDSkeletonBone >> index [

	^ index
]

{ #category : 'accessing' }
WDSkeletonBone >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WDSkeletonBone >> initialize [
	super initialize.
	name := ''.
	transform := TRSTransform3D identity.
	baseGlobalTransform := TRSTransform3D identity.
	parentIndex := -1.
	index := -1.
]

{ #category : 'matrix' }
WDSkeletonBone >> matrix [
	^ transform matrix4
]

{ #category : 'accessing' }
WDSkeletonBone >> name [

	^ name
]

{ #category : 'accessing' }
WDSkeletonBone >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSkeletonBone >> parentIndex [

	^ parentIndex
]

{ #category : 'accessing' }
WDSkeletonBone >> parentIndex: anObject [

	parentIndex := anObject
]

{ #category : 'accessing' }
WDSkeletonBone >> transform [

	^ transform
]

{ #category : 'accessing' }
WDSkeletonBone >> transform: anObject [

	transform := anObject
]
