"
I am a model animation that can be attached to a node hierarchy.
"
Class {
	#name : #WDModelAnimation,
	#superclass : #Object,
	#instVars : [
		'name',
		'channels'
	],
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #'as yet unclassified' }
WDModelAnimation >> applyPosition: position looped: isLooped toSkeletonPose: skeletonPose withBoneMap: boneMap [
	| bonePoses inputSampleCache |
	bonePoses := skeletonPose bonePoses.
	inputSampleCache := nil.
	
	boneMap boneIndices doWithIndex: [ :boneIndex :channelIndex |
		boneIndex ifNotNil: [ 
			| bonePose channel |
			bonePose := bonePoses at: boneIndex.
			channel := channels at: channelIndex.
			inputSampleCache := channel applyPosition: position looped: isLooped inputSampleCache: inputSampleCache toBonePose: bonePose
		]
	]
]

{ #category : #accessing }
WDModelAnimation >> channels [

	^ channels
]

{ #category : #accessing }
WDModelAnimation >> channels: anObject [

	channels := anObject
]

{ #category : #'as yet unclassified' }
WDModelAnimation >> makeBoneMapForSkeleton: skeleton [
	^ WDModelAnimationBoneMap new
		skeleton: skeleton;
		boneIndices: (channels collect: [:each | skeleton mapBoneNameToIndexOrNil: each targetName]);
		yourself
]

{ #category : #accessing }
WDModelAnimation >> name [

	^ name
]

{ #category : #accessing }
WDModelAnimation >> name: anObject [

	name := anObject
]
