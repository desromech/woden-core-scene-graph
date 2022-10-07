"
I encapsulate the pose for a specific skeleton.
"
Class {
	#name : #WDSkeletonPose,
	#superclass : #Object,
	#instVars : [
		'skeleton',
		'bonePoses',
		'renderingPoseState',
		'skinningMatrices',
		'forwardMatrices',
		'poseMatrices'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #converting }
WDSkeletonPose >> asPoseState [
	^ renderingPoseState ifNil: [ renderingPoseState := WDRenderingPoseState new
		skinningMatrices: self skinningMatrices;
		yourself
	]
]

{ #category : #accessing }
WDSkeletonPose >> bonePoses [

	^ bonePoses
]

{ #category : #accessing }
WDSkeletonPose >> bonePoses: anObject [

	bonePoses := anObject
]

{ #category : #converting }
WDSkeletonPose >> forwardMatrices [
	^ forwardMatrices ifNil: [ forwardMatrices := skeleton computeForwardMatricesWithPoseMatrices: self poseMatrices ]
]

{ #category : #initialization }
WDSkeletonPose >> initialize [
	super initialize.
	bonePoses := #()
]

{ #category : #scrolling }
WDSkeletonPose >> invalidate [
	poseMatrices := nil.
	forwardMatrices := nil.
	skinningMatrices := nil.
	renderingPoseState := nil.

]

{ #category : #converting }
WDSkeletonPose >> poseMatrices [
	^ poseMatrices ifNil: [ poseMatrices := bonePoses collect: [ :each | each matrix4 ] ]
]

{ #category : #initialization }
WDSkeletonPose >> setForRestPose [
	bonePoses := skeleton bones collect: [ :each | each transform copy ].
	self invalidate
]

{ #category : #accessing }
WDSkeletonPose >> skeleton [

	^ skeleton
]

{ #category : #accessing }
WDSkeletonPose >> skeleton: anObject [

	skeleton := anObject
]

{ #category : #converting }
WDSkeletonPose >> skinningMatrices [
	^ skinningMatrices ifNil: [ skinningMatrices := skeleton computeSkinningMatricesWithForwardMatrices: self forwardMatrices ]
]
