"
I keep a map for the animated elements in a scene node subtree.
"
Class {
	#name : 'WDSceneAnimationSubtreeMap',
	#superclass : 'Object',
	#instVars : [
		'targetNameDictionary',
		'skeletonPoseDictionary',
		'skeletonPoses',
		'nodes'
	],
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> addLightSource: lightSource [
]

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> addNode: node [
	node name ifNil: [ ^ self ].
	node name ifEmpty: [ ^ self ].
	
	nodes add: node.
	(self getOrCreateNameMapFor: node name) addNode: node
]

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> addSkeletalMesh: skeletalMesh [
	| skeleton skeletonPose |
	skeleton := skeletalMesh skeleton.
	skeleton ifNil: [ ^ self ].

	skeletonPose := skeletonPoseDictionary at: skeleton ifAbsentPut: [
		| newPose |
		newPose := skeleton restPose.
		self addSkeletonPose: newPose.
		newPose
	].
	skeletalMesh currentPose: skeletonPose
]

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> addSkeletonPose: pose [
	skeletonPoses add: pose.
	pose skeleton bones doWithIndex: [ :bone :boneIndex |
		(self getOrCreateNameMapFor: bone name) addPose: pose boneIndex: boneIndex
	]
]

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> getOrCreateNameMapFor: targetName [
	^ targetNameDictionary at: targetName ifAbsentPut: [WDSceneAnimationSubtreeNameMap new]
]

{ #category : 'initialization' }
WDSceneAnimationSubtreeMap >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	skeletonPoses := OrderedCollection new.
	skeletonPoseDictionary := Dictionary new.
	targetNameDictionary := Dictionary new.
]

{ #category : 'adding' }
WDSceneAnimationSubtreeMap >> mapNameToTargetOrNil: targetName [
	^ targetNameDictionary at: targetName ifAbsent: [nil]
]

{ #category : 'initialization' }
WDSceneAnimationSubtreeMap >> setForRestPose [
	skeletonPoses do: [ :each | each setForRestPose ].
]

{ #category : 'accessing' }
WDSceneAnimationSubtreeMap >> skeletonPoses [
	^ skeletonPoses
]
