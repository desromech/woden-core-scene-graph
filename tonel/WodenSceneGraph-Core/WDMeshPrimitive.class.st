"
I represent a set of primitives in a mesh.

I have direct correspondence with a gltf 2 mesh primitive.
"
Class {
	#name : #WDMeshPrimitive,
	#superclass : #WDRenderable,
	#instVars : [
		'material',
		'vertexBinding',
		'indices',
		'topology',
		'boundingBox'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #adding }
WDMeshPrimitive >> addIntoModelAssetWithDependencies: modelAsset [
	material ifNotNil: [ 
		material addIntoModelAssetWithDependencies: modelAsset
	]
]

{ #category : #adding }
WDMeshPrimitive >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	(renderingScene shouldRenderBoundingBox: self boundingBox withObjectState: anObjectState) ifTrue: [ 
		renderingScene addMeshPrimitive: self withMaterial: material objectState: anObjectState
	]
]

{ #category : #accessing }
WDMeshPrimitive >> boundingBox [

	^ boundingBox
]

{ #category : #accessing }
WDMeshPrimitive >> boundingBox: anObject [

	boundingBox := anObject
]

{ #category : #copying }
WDMeshPrimitive >> copyTransformingMaterialsWith: aBlock [
	^ self copy
		material: (aBlock value: material);
		yourself
]

{ #category : #copying }
WDMeshPrimitive >> copyWithMaterial: aMaterial [
	^ self copy
		material: aMaterial;
		yourself
]

{ #category : #'double dispatch' }
WDMeshPrimitive >> emitRenderingCommandsWithRenderer: renderer [
	renderer emitRenderingCommandsForMeshPrimitive: self
]

{ #category : #accessing }
WDMeshPrimitive >> indices [

	^ indices
]

{ #category : #accessing }
WDMeshPrimitive >> indices: anObject [

	indices := anObject
]

{ #category : #initialization }
WDMeshPrimitive >> initialize [
	super initialize.
	self topology: WDPrimitiveTopologyPoints.
]

{ #category : #accessing }
WDMeshPrimitive >> material [

	^ material
]

{ #category : #accessing }
WDMeshPrimitive >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDMeshPrimitive >> topology [

	^ topology
]

{ #category : #accessing }
WDMeshPrimitive >> topology: aPrimitiveTopology [
	topology := aPrimitiveTopology asPrimitiveTopology
]

{ #category : #accessing }
WDMeshPrimitive >> vertexBinding [

	^ vertexBinding
]

{ #category : #accessing }
WDMeshPrimitive >> vertexBinding: anObject [

	vertexBinding := anObject
]
