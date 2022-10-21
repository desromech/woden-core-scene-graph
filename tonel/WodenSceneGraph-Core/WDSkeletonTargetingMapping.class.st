"
I hold a mapping between bone rest pose transforms that is used for retargeting animations from one skeleton into another one.
"
Class {
	#name : #WDSkeletonTargetingMapping,
	#superclass : #Object,
	#instVars : [
		'restPoseTransforms'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #initialization }
WDSkeletonTargetingMapping >> initialize [
	restPoseTransforms := Dictionary new.
]

{ #category : #initialization }
WDSkeletonTargetingMapping >> setBone: boneName restPoseTransform: transform [
	restPoseTransforms at: boneName put: transform
]

{ #category : #'as yet unclassified' }
WDSkeletonTargetingMapping >> transformBone: boneName rotation: rotation [
	^ rotation"(restPoseTransforms at: boneName ifAbsent: [ nil ])
		ifNil: [ rotation ]
		ifNotNil: [ :transform | transform rotation * rotation ]"
]

{ #category : #'as yet unclassified' }
WDSkeletonTargetingMapping >> transformBone: boneName scale: scale [
	^ scale
]

{ #category : #'as yet unclassified' }
WDSkeletonTargetingMapping >> transformBone: boneName translation: translation [
	^ (restPoseTransforms at: boneName ifAbsent: [ nil ])
		ifNil: [ translation ]
		ifNotNil: [ :transform | transform scale * translation ]
]
