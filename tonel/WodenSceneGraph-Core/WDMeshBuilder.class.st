Class {
	#name : #WDMeshBuilder,
	#superclass : #Object,
	#instVars : [
		'positions',
		'colors',
		'texcoords',
		'normals',
		'indices',
		'primitives',
		'vertexCount'
	],
	#category : #'WodenSceneGraph-Core-RenderableBuilder'
}

{ #category : #adding }
WDMeshBuilder >> addPx: x y: y z: z [
	positions add: x; add: y; add: z.
	vertexCount := vertexCount + 1.
]

{ #category : #adding }
WDMeshBuilder >> addTriangleI0: i0 i1: i1 i2: i3 [
	indices add: i0; add: i1; add: i3
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> beginPrimitiveWithTopology: topology [
	^ self beginPrimitiveWithTopology: topology material: self currentMaterial
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> beginPrimitiveWithTopology: topology material: material [

	primitives add: (WDMeshPrimitive new
		material: material;
		topology: topology;
		indices: (WDBinaryBufferAccessor new
			byteOffset: indices size;
			yourself))
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> beginTriangles [
	^ self beginPrimitiveWithTopology: WDPrimitiveTopologyTriangles
]

{ #category : #accessing }
WDMeshBuilder >> colors [

	^ colors
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> currentMaterial [
	^ primitives ifEmpty: [ nil ] ifNotEmpty: [ primitives last material ]
]

{ #category : #accessing }
WDMeshBuilder >> indices [

	^ indices
]

{ #category : #initialization }
WDMeshBuilder >> initialize [
	super initialize.
	positions := OrderedCollection new.
	colors := OrderedCollection new.
	texcoords := OrderedCollection new.
	normals := OrderedCollection new.
	indices := OrderedCollection new.
	primitives := OrderedCollection new.
	self reset.
]

{ #category : #builder }
WDMeshBuilder >> mesh [
	^ WDStaticMeshRenderable new
]

{ #category : #accessing }
WDMeshBuilder >> normals [

	^ normals
]

{ #category : #accessing }
WDMeshBuilder >> positions [

	^ positions
]

{ #category : #accessing }
WDMeshBuilder >> primitives [

	^ primitives
]

{ #category : #initialization }
WDMeshBuilder >> reset [
	positions removeAll.
	colors removeAll.
	texcoords removeAll.
	normals removeAll.
	indices removeAll.
	primitives removeAll.
	vertexCount := 0.

]

{ #category : #accessing }
WDMeshBuilder >> texcoords [

	^ texcoords
]

{ #category : #accessing }
WDMeshBuilder >> vertexCount [
	^ vertexCount
]
