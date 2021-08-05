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
WDMeshPrimitive >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	renderingScene addMeshPrimitive: self withMaterial: material objectState: anObjectState
]

{ #category : #accessing }
WDMeshPrimitive >> boundingBox [

	^ boundingBox
]

{ #category : #accessing }
WDMeshPrimitive >> boundingBox: anObject [

	boundingBox := anObject
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
