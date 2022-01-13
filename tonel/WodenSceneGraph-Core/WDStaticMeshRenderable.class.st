"
I am a renderable that holds a static mesh.
"
Class {
	#name : #WDStaticMeshRenderable,
	#superclass : #WDRenderable,
	#instVars : [
		'primitives',
		'boundingBox'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #adding }
WDStaticMeshRenderable >> addIntoModelAssetWithDependencies: modelAsset [
	modelAsset addMesh: self.
	primitives do: [ :each | each addIntoModelAssetWithDependencies: modelAsset ]
]

{ #category : #adding }
WDStaticMeshRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	primitives do: [ :each |
		each addToRenderingScene: renderingScene withObjectState: anObjectState
	].
]

{ #category : #accessing }
WDStaticMeshRenderable >> boundingBox [

	^ boundingBox
]

{ #category : #accessing }
WDStaticMeshRenderable >> boundingBox: anObject [

	boundingBox := anObject
]

{ #category : #'as yet unclassified' }
WDStaticMeshRenderable >> computeBoundingBoxFromPrimitives [
	boundingBox := AABox empty.
	primitives do: [ :each |
		boundingBox insertBox: each boundingBox
	].
]

{ #category : #copying }
WDStaticMeshRenderable >> copyTransformingMaterialsWith: aBlock [
	^ self copy
		primitives: (primitives collect: [:each | each copyTransformingMaterialsWith: aBlock ]);
		yourself
]

{ #category : #copying }
WDStaticMeshRenderable >> copyWithMaterial: aMaterial [
	^ self copy
		primitives: (primitives collect: [:each | each copyWithMaterial: aMaterial ]);
		yourself
]

{ #category : #initialization }
WDStaticMeshRenderable >> initialize [
	super initialize.
	primitives := #().
	boundingBox := AABox empty.
]

{ #category : #accessing }
WDStaticMeshRenderable >> primitives [

	^ primitives
]

{ #category : #accessing }
WDStaticMeshRenderable >> primitives: anObject [

	primitives := anObject
]
