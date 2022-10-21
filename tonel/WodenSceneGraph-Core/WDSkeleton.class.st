"
I am an a skeleton that is used by a skeletal mesh.
"
Class {
	#name : #WDSkeleton,
	#superclass : #Object,
	#instVars : [
		'name',
		'rootMatrix',
		'bones',
		'rootBoneIndex',
		'restPoseInverseMatrices',
		'restPoseForwardMatrices',
		'boneNameToIndexDictionary',
		'skinningOrderTable',
		'inverseRootMatrix'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #accessing }
WDSkeleton >> boneNameToIndexDictionary [
	boneNameToIndexDictionary ifNil: [ 
		boneNameToIndexDictionary := Dictionary new.
		bones doWithIndex: [ :eachBone :index |
			boneNameToIndexDictionary at: eachBone name put: index
		]
	].

	^ boneNameToIndexDictionary 
]

{ #category : #accessing }
WDSkeleton >> bones [

	^ bones
]

{ #category : #accessing }
WDSkeleton >> bones: anObject [
	bones := anObject.
	boneNameToIndexDictionary := nil.
]

{ #category : #'as yet unclassified' }
WDSkeleton >> computeBoneSkinningOrderFrom: boneIndex into: result set: resultSet [
	| parentIndex |
	(resultSet includes: boneIndex) ifTrue: [ ^ self ].
	resultSet add: boneIndex.
	
	parentIndex := (bones at: boneIndex) parentIndex.
	parentIndex >= 0 ifTrue: [
		self computeBoneSkinningOrderFrom: parentIndex + 1 into: result set: resultSet
	].

	result add: boneIndex
]

{ #category : #'pose matrices' }
WDSkeleton >> computeForwardMatricesWithPoseMatrices: poseMatrices [
	| result matrix |
	self assert: poseMatrices size = bones size.
	result := Array new: bones size.
	skinningOrderTable do: [ :boneIndex |
		| bone |
		bone := bones at: boneIndex.
		matrix := poseMatrices at: boneIndex.
		bone parentIndex >= 0 ifTrue: [
			matrix := (result at: bone parentIndex + 1) * matrix
		].
	
		result at: boneIndex put: matrix
	].
	^ result
]

{ #category : #'pose matrices' }
WDSkeleton >> computeRestPoseForwardMatrices [
	restPoseForwardMatrices := self computeForwardMatricesWithPoseMatrices: (bones collect: [:each | each matrix]).
	
	self computeSkinningMatricesWithForwardMatrices: restPoseForwardMatrices.
]

{ #category : #'pose matrices' }
WDSkeleton >> computeSkinningMatricesWithForwardMatrices: forwardMatrices [
	| result |
	self assert: forwardMatrices size = bones size.
	result := Array new: restPoseInverseMatrices size.
	restPoseInverseMatrices doWithIndex: [ :restPoseInverseMatrix :boneIndex |
		result at: boneIndex put: inverseRootMatrix * ((forwardMatrices at: boneIndex) * restPoseInverseMatrix)
	].

	^ result
]

{ #category : #'as yet unclassified' }
WDSkeleton >> computeSkinningOrderTable [
	| result resultSet |
	result := OrderedCollection new.
	resultSet := Set new.
	1 to: bones size do: [ :boneIndex |
		self computeBoneSkinningOrderFrom: boneIndex into: result set: resultSet
	].
	self assert: result size = bones size.
	skinningOrderTable := result asArray.

]

{ #category : #'as yet unclassified' }
WDSkeleton >> constructPerBoneSkeletonTargetingMappingInto: targetSkeleton [
	| mapping |
	mapping := WDPerBoneSkeletonTargetingMapping new.
	bones do:[ :sourceBone |
		| boneName |
		boneName := sourceBone name.
		(targetSkeleton getBoneNamedOrNil: boneName) ifNotNil: [ :targetBone |
			| transform |
			transform := targetBone baseGlobalTransform inverseTransformTransform: sourceBone baseGlobalTransform.
			mapping setBone: boneName restPoseTransform: transform asTRSTransform3D
		]
	].
	
	^ mapping
]

{ #category : #'as yet unclassified' }
WDSkeleton >> constructScaleRotationSkeletonTargetingMappingInto: targetSkeleton [
	| mapping |
	mapping := WDScaleRotationSkeletonTargetingMapping new.
	targetSkeleton rootBone ifNotNil: [ :targetRootBone |
		mapping rootBoneName: targetRootBone name.
		(self getBoneNamedOrNil: targetRootBone name) ifNotNil: [ :sourceRootBone |
			| transform trsTransform |
			transform := targetRootBone baseGlobalTransform inverseTransformTransform: sourceRootBone baseGlobalTransform.
			trsTransform := transform asTRSTransform3D.
			mapping
				scale: trsTransform scale;
				rotation: trsTransform rotation
		]
	].

	^ mapping
]

{ #category : #'as yet unclassified' }
WDSkeleton >> getBoneNamedOrNil: boneName [
	^ (self mapBoneNameToIndexOrNil: boneName) ifNotNil: [ :boneIndex | bones at: boneIndex ]
]

{ #category : #initialization }
WDSkeleton >> initialize [
	super initialize.
	name := ''.
	rootMatrix := Matrix4x4 identity.
	restPoseInverseMatrices := #().
	skinningOrderTable := #().
]

{ #category : #accessing }
WDSkeleton >> inverseRootMatrix [
	^ inverseRootMatrix
]

{ #category : #'as yet unclassified' }
WDSkeleton >> mapBoneNameToIndexOrNil: boneName [
	^ self boneNameToIndexDictionary at: boneName ifAbsent: [ nil ]
]

{ #category : #accessing }
WDSkeleton >> name [

	^ name
]

{ #category : #accessing }
WDSkeleton >> name: anObject [

	name := anObject
]

{ #category : #removing }
WDSkeleton >> removePrefixFromBoneNames: prefixToRemove [
	bones do: [ :each | each name: (each name withoutPrefix: prefixToRemove) ].
	boneNameToIndexDictionary := nil.
]

{ #category : #poses }
WDSkeleton >> restPose [
	^ WDSkeletonPose new
		skeleton: self;
		setForRestPose; 
		yourself
]

{ #category : #accessing }
WDSkeleton >> restPoseForwardMatrices [
	^ restPoseForwardMatrices
]

{ #category : #accessing }
WDSkeleton >> restPoseForwardMatrices: anObject [

	restPoseForwardMatrices := anObject
]

{ #category : #accessing }
WDSkeleton >> restPoseInverseMatrices [

	^ restPoseInverseMatrices
]

{ #category : #accessing }
WDSkeleton >> restPoseInverseMatrices: anObject [

	restPoseInverseMatrices := anObject
]

{ #category : #accessing }
WDSkeleton >> rootBone [
	^ rootBoneIndex ifNotNil: [ bones at: rootBoneIndex + 1 ]
]

{ #category : #accessing }
WDSkeleton >> rootBoneIndex [

	^ rootBoneIndex
]

{ #category : #accessing }
WDSkeleton >> rootBoneIndex: anObject [

	rootBoneIndex := anObject
]

{ #category : #accessing }
WDSkeleton >> rootMatrix [

	^ rootMatrix
]

{ #category : #accessing }
WDSkeleton >> rootMatrix: anObject [
	rootMatrix := anObject.
	inverseRootMatrix := rootMatrix inverse.
]
