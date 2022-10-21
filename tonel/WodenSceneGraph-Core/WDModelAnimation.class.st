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

{ #category : #animation }
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

{ #category : #animation }
WDModelAnimation >> applyPosition: position looped: isLooped toSubtreeChannelMap: subtreeChannelMap [
	| inputSampleCache |
	inputSampleCache := nil.
	subtreeChannelMap targets doWithIndex: [ :target :channelIndex |
		target ifNotNil: [
			| channel |
			channel := channels at: channelIndex.
			inputSampleCache := channel applyPosition: position looped: isLooped inputSampleCache: inputSampleCache toSubtreeChannel: target
		]
	]
]

{ #category : #removing }
WDModelAnimation >> applySkeletonTargetingMapping: skeletonTargetingMapping [
	channels do: [ :each |
		each targetName ifNotNil: [ 
			each applySkeletonTargetingMapping: skeletonTargetingMapping
		].
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

{ #category : #animation }
WDModelAnimation >> makeBoneMapForSkeleton: skeleton [
	^ WDModelAnimationBoneMap new
		skeleton: skeleton;
		boneIndices: (channels collect: [:each | skeleton mapBoneNameToIndexOrNil: each targetName]);
		yourself
]

{ #category : #animation }
WDModelAnimation >> makeSubtreeChannelMapFor: subtreeMap [
	^ WDModelAnimationSubtreeChannelMap new
		subtreeMap: subtreeMap;
		targets: (channels collect: [:each | subtreeMap mapNameToTargetOrNil: each targetName]);
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

{ #category : #removing }
WDModelAnimation >> removePrefixFromChannelTargets: prefix [
	channels do: [ :each |
		each targetName ifNotNil: [ 
			each targetName: (each targetName withoutPrefix: prefix)
		].
	]
]
