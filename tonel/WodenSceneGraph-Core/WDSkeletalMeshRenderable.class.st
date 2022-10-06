"
I am a renderable that holds a mesh with skeletal animation deformation data.
"
Class {
	#name : #WDSkeletalMeshRenderable,
	#superclass : #WDRenderable,
	#instVars : [
		'referenceMesh',
		'skeleton',
		'currentPose'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #adding }
WDSkeletalMeshRenderable >> addIntoModelAssetWithDependencies: modelAsset [
	modelAsset addSkeletalMesh: self.
	referenceMesh addIntoModelAssetWithDependencies: modelAsset.
]

{ #category : #adding }
WDSkeletalMeshRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	referenceMesh ifNotNil: [
		(skeleton isNotNil and: [ currentPose isNotNil ]) ifTrue: [ 
			referenceMesh addToRenderingScene: renderingScene withObjectState: anObjectState poseState: currentPose asPoseState
		] ifFalse: [ 
			referenceMesh addToRenderingScene: renderingScene withObjectState: anObjectState
		]
	]
]

{ #category : #adding }
WDSkeletalMeshRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState [
	referenceMesh ifNotNil: [
		referenceMesh addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState
	]
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> boundingBox [
	^ referenceMesh boundingBox scaledBy: 3
]

{ #category : #copying }
WDSkeletalMeshRenderable >> copyTransformingMaterialsWith: aBlock [
	^ self
		referenceMesh: (referenceMesh copyTransformingMaterialsWith: aBlock);
		yourself
]

{ #category : #copying }
WDSkeletalMeshRenderable >> copyWithMaterial: aMaterial [
	^ self
		referenceMesh: (referenceMesh copyWithMaterial: aMaterial);
		yourself
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> currentPose [

	^ currentPose
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> currentPose: anObject [

	currentPose := anObject
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> referenceMesh [

	^ referenceMesh
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> referenceMesh: anObject [

	referenceMesh := anObject
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> skeleton [

	^ skeleton
]

{ #category : #accessing }
WDSkeletalMeshRenderable >> skeleton: anObject [

	skeleton := anObject
]
