Class {
	#name : #WDSceneAnimationSubtreeNameMap,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'bonePoses'
	],
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #adding }
WDSceneAnimationSubtreeNameMap >> addNode: aNode [
	nodes add: aNode
]

{ #category : #adding }
WDSceneAnimationSubtreeNameMap >> addPose: pose boneIndex: boneIndex [
	bonePoses add: (WDSceneAnimationSubtreeBonePoseTarget new
		pose: pose;
		boneIndex: boneIndex;
		yourself)
]

{ #category : #adding }
WDSceneAnimationSubtreeNameMap >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	bonePoses := OrderedCollection new.
]

{ #category : #accessing }
WDSceneAnimationSubtreeNameMap >> rotation: rotation [
	bonePoses do: [ :each | each rotation: rotation ]
]

{ #category : #accessing }
WDSceneAnimationSubtreeNameMap >> scale: scale [
	bonePoses do: [ :each | each scale: scale ]
]

{ #category : #accessing }
WDSceneAnimationSubtreeNameMap >> translation: translation [
	bonePoses do: [ :each | each translation: translation ]
]

{ #category : #accessing }
WDSceneAnimationSubtreeNameMap >> weights: rotation [
]
