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
