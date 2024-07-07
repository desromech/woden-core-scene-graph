Class {
	#name : 'WDModelAnimationBoneMap',
	#superclass : 'Object',
	#instVars : [
		'skeleton',
		'boneIndices'
	],
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'accessing' }
WDModelAnimationBoneMap >> boneIndices [

	^ boneIndices
]

{ #category : 'accessing' }
WDModelAnimationBoneMap >> boneIndices: anObject [

	boneIndices := anObject
]

{ #category : 'accessing' }
WDModelAnimationBoneMap >> skeleton [

	^ skeleton
]

{ #category : 'accessing' }
WDModelAnimationBoneMap >> skeleton: anObject [

	skeleton := anObject
]
