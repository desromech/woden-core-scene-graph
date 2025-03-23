"
I represent a set of primitives in a mesh.

I have direct correspondence with a gltf 2 mesh primitive.
"
Class {
	#name : 'WDMeshPrimitive',
	#superclass : 'WDRenderable',
	#instVars : [
		'material',
		'vertexBinding',
		'indices',
		'topology',
		'boundingBox'
	],
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'adding' }
WDMeshPrimitive >> addIntoModelAssetWithDependencies: modelAsset [
	material ifNotNil: [ 
		material addIntoModelAssetWithDependencies: modelAsset
	]
]

{ #category : 'adding' }
WDMeshPrimitive >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	(renderingScene shouldRenderBoundingBox: self boundingBox withObjectState: anObjectState) ifTrue: [ 
		renderingScene addMeshPrimitive: self withMaterial: material objectState: anObjectState
	]
]

{ #category : 'adding' }
WDMeshPrimitive >> addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState [
	(renderingScene shouldRenderBoundingBox: self boundingBox withObjectState: anObjectState poseState: poseState) ifTrue: [ 
		renderingScene addMeshPrimitive: self withMaterial: material objectState: anObjectState poseState: poseState
	]
]

{ #category : 'accessing' }
WDMeshPrimitive >> boundingBox [

	^ boundingBox
]

{ #category : 'accessing' }
WDMeshPrimitive >> boundingBox: anObject [

	boundingBox := anObject
]

{ #category : 'as yet unclassified' }
WDMeshPrimitive >> computeBoundingBoxFromVertexBindingData [
	| positionAccessor |
	vertexBinding ifNil: [ ^ self ].
	positionAccessor := vertexBinding positionAccessor.
	(positionAccessor min isNotNil and: [ positionAccessor max isNotNil ]) ifTrue: [ 
		self boundingBox: (AABox min: positionAccessor min max: positionAccessor max)
	].
]

{ #category : 'copying' }
WDMeshPrimitive >> copyTransformingMaterialsWith: aBlock [
	^ self copy
		material: (aBlock value: material);
		yourself
]

{ #category : 'copying' }
WDMeshPrimitive >> copyWithMaterial: aMaterial [
	^ self copy
		material: aMaterial;
		yourself
]

{ #category : 'double dispatch' }
WDMeshPrimitive >> emitRenderingCommandsWithRenderer: renderer [
	renderer emitRenderingCommandsForMeshPrimitive: self
]

{ #category : 'as yet unclassified' }
WDMeshPrimitive >> exportToGltfWith: builder [
	| primitive |
	primitive := builder newPrimitive.
	vertexBinding attributes do: [:each |
		| attribute |
		attribute := builder mapVertexLocationToAttribute: each location.
		primitive attributes at: attribute put: (builder convertAccessor: each accessor)
	].

	indices ifNotNil: [ 
		primitive indices: (builder convertAccessor: indices)
	].
	^ primitive
]

{ #category : 'accessing' }
WDMeshPrimitive >> indices [

	^ indices
]

{ #category : 'accessing' }
WDMeshPrimitive >> indices: anObject [

	indices := anObject
]

{ #category : 'initialization' }
WDMeshPrimitive >> initialize [
	super initialize.
	self topology: WDPrimitiveTopologyPoints.
	boundingBox := AABox originPoint.
]

{ #category : 'accessing' }
WDMeshPrimitive >> material [

	^ material
]

{ #category : 'accessing' }
WDMeshPrimitive >> material: anObject [

	material := anObject
]

{ #category : 'accessing' }
WDMeshPrimitive >> topology [

	^ topology
]

{ #category : 'accessing' }
WDMeshPrimitive >> topology: aPrimitiveTopology [
	topology := aPrimitiveTopology asPrimitiveTopology
]

{ #category : 'accessing' }
WDMeshPrimitive >> vertexBinding [

	^ vertexBinding
]

{ #category : 'accessing' }
WDMeshPrimitive >> vertexBinding: anObject [

	vertexBinding := anObject
]
