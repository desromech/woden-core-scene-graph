Class {
	#name : 'WDSceneAnimationSubtreeBonePoseTarget',
	#superclass : 'Object',
	#instVars : [
		'pose',
		'boneIndex'
	],
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> boneIndex [

	^ boneIndex
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> boneIndex: anObject [

	boneIndex := anObject
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> pose [

	^ pose
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> pose: anObject [

	pose := anObject
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> rotation: rotation [
	(pose bonePoses at: boneIndex) rotation: rotation
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> scale: scale [
	(pose bonePoses at: boneIndex) scale: scale
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeBonePoseTarget >> translation: translation [
	(pose bonePoses at: boneIndex) translation: translation
]
