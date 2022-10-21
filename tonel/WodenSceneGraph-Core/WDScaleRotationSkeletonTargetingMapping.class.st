Class {
	#name : #WDScaleRotationSkeletonTargetingMapping,
	#superclass : #WDAbstractSkeletonTargetingMapping,
	#instVars : [
		'scale',
		'rotation',
		'rootBoneName'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #initialization }
WDScaleRotationSkeletonTargetingMapping >> initialize [
	super initialize.
	scale := Vector3 ones.
	rotation := Quaternion identity.
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> rootBoneName [

	^ rootBoneName
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> rootBoneName: anObject [

	rootBoneName := anObject
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> rotation [

	^ rotation
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> rotation: anObject [

	rotation := anObject
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> scale [

	^ scale
]

{ #category : #accessing }
WDScaleRotationSkeletonTargetingMapping >> scale: anObject [

	scale := anObject
]

{ #category : #'as yet unclassified' }
WDScaleRotationSkeletonTargetingMapping >> transformBone: boneName rotation: boneRotation [
	^ boneName = rootBoneName
		ifTrue: [ rotation * boneRotation ]
		ifFalse: [ boneRotation ]
]

{ #category : #'as yet unclassified' }
WDScaleRotationSkeletonTargetingMapping >> transformBone: boneName scale: boneScale [
	^ boneScale
]

{ #category : #'as yet unclassified' }
WDScaleRotationSkeletonTargetingMapping >> transformBone: boneName translation: translation [
	^ boneName = rootBoneName
		ifTrue: [ rotation transformVector3: translation * scale ]
		ifFalse: [ translation * scale ]
]
