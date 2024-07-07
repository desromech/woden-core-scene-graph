Class {
	#name : 'WDAbstractSkeletonTargetingMapping',
	#superclass : 'Object',
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'as yet unclassified' }
WDAbstractSkeletonTargetingMapping >> transformBone: boneName rotation: rotation [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
WDAbstractSkeletonTargetingMapping >> transformBone: boneName scale: scale [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
WDAbstractSkeletonTargetingMapping >> transformBone: boneName translation: translation [
	self subclassResponsibility
]
