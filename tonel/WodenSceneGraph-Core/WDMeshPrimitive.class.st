"
I represent a set of primitives in a mesh.

I have direct correspondence with a gltf 2 mesh primitive.
"
Class {
	#name : #WDMeshPrimitive,
	#superclass : #Object,
	#instVars : [
		'material',
		'vertexBinding',
		'indices',
		'topology'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

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
