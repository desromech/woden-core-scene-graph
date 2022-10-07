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
		'restPoseInverseMatrices',
		'jointIndexToBoneIndexPermutationTable',
		'restPoseForwardMatrices'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #accessing }
WDSkeleton >> bones [

	^ bones
]

{ #category : #accessing }
WDSkeleton >> bones: anObject [

	bones := anObject
]

{ #category : #'pose matrices' }
WDSkeleton >> computeForwardMatricesWithPoseMatrices: poseMatrices [
	| result matrix |
	self assert: poseMatrices size = bones size.
	result := Array new: bones size.
	bones doWithIndex: [ :bone :boneIndex |
		matrix := poseMatrices at: boneIndex.
		bone parentIndex >= 0 ifTrue: [
			matrix := (result at: bone parentIndex + 1) * matrix
		] ifFalse: [ 
			matrix := rootMatrix * matrix
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
	| result permutation |
	self assert: forwardMatrices size = bones size.
	permutation := self jointIndexToBoneIndexPermutationTable.
	result := Array new: permutation size.
	permutation doWithIndex: [ :boneIndex :resultIndex |
		| permuttedIndex |
		permuttedIndex := boneIndex + 1.
		result at: resultIndex put: (forwardMatrices at: permuttedIndex) * (restPoseInverseMatrices at: permuttedIndex)
	].

	^ result
]

{ #category : #initialization }
WDSkeleton >> initialize [
	super initialize.
	name := ''.
	rootMatrix := Matrix4x4 identity.
	jointIndexToBoneIndexPermutationTable := #().
	restPoseInverseMatrices := #().
]

{ #category : #accessing }
WDSkeleton >> jointIndexToBoneIndexPermutationTable [

	^ jointIndexToBoneIndexPermutationTable
]

{ #category : #accessing }
WDSkeleton >> jointIndexToBoneIndexPermutationTable: anObject [

	jointIndexToBoneIndexPermutationTable := anObject
]

{ #category : #accessing }
WDSkeleton >> name [

	^ name
]

{ #category : #accessing }
WDSkeleton >> name: anObject [

	name := anObject
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
WDSkeleton >> rootMatrix [

	^ rootMatrix
]

{ #category : #accessing }
WDSkeleton >> rootMatrix: anObject [

	rootMatrix := anObject
]
