"
I am an utilty for building renderable meshes.
"
Class {
	#name : #WDMeshBuilder,
	#superclass : #Object,
	#instVars : [
		'positions',
		'colors',
		'normals',
		'tangents4',
		'boneIndices',
		'boneWeights',
		'indices',
		'primitives',
		'vertexCount',
		'vertexBinding',
		'buffer',
		'vertexBufferView',
		'indexBufferView',
		'texcoords0',
		'texcoords1',
		'baseVertex'
	],
	#category : #'WodenSceneGraph-Core-RenderableBuilder'
}

{ #category : #adding }
WDMeshBuilder >> addCr: r g: g b: b a: a [
	colors add: r; add: g; add: b; add: a.
]

{ #category : #adding }
WDMeshBuilder >> addCubeMinX: minX y: minY z: minZ maxX: maxX y: maxY z: maxZ [
	self
		"Left"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: minX y: maxY z: minZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: minX y: maxY z: maxZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: minX y: minY z: maxZ; addNx: -1.0 y: 0.0 z: 0.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0;

		"Right"
		beginTriangles;
		addPx: maxX y: minY z: minZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: maxX y: maxY z: minZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: maxX y: maxY z: maxZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: maxX y: minY z: maxZ; addNx: 1.0 y: 0.0 z: 0.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0;

		"Top"
		beginTriangles;
		addPx: minX y: maxY z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: maxY z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: maxY z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: minX y: maxY z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0;

		"Bottom"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: maxX y: minY z: minZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: maxX y: minY z: maxZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: minX y: minY z: maxZ; addNx: 0.0 y: -1.0 z: 0.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0;

		"Back"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: maxX y: minY z: minZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: maxX y: maxY z: minZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: minX y: maxY z: minZ; addNx: 0.0 y: 0.0 z: -1.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0;

		"Front"
		beginTriangles;
		addPx: minX y: minY z: maxZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: maxX y: minY z: maxZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: maxX y: maxY z: maxZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: minX y: maxY z: maxZ; addNx: 0.0 y: 0.0 z: 1.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0
]

{ #category : #adding }
WDMeshBuilder >> addNx: x y: y z: z [
	normals add: x; add: y; add: z.
]

{ #category : #adding }
WDMeshBuilder >> addPx: x y: y z: z [
	positions add: x; add: y; add: z.
	vertexCount := vertexCount + 1.
]

{ #category : #adding }
WDMeshBuilder >> addT0u: u v: v [
	texcoords0 add: u; add: v
]

{ #category : #adding }
WDMeshBuilder >> addT1u: u v: v [
	texcoords1 add: u; add: v
]

{ #category : #adding }
WDMeshBuilder >> addTriangleI0: i0 i1: i1 i2: i3 [
	indices add: i0 + baseVertex ; add: i1 + baseVertex; add: i3 + baseVertex
]

{ #category : #builder }
WDMeshBuilder >> beginPrimitiveWithTopology: topology [
	^ self beginPrimitiveWithTopology: topology material: self currentMaterial
]

{ #category : #builder }
WDMeshBuilder >> beginPrimitiveWithTopology: topology material: material [
	primitives isEmpty ifFalse: [ 
		| lastPrimitive |
		lastPrimitive := primitives last.
		(lastPrimitive material == material and: [ lastPrimitive topology == topology asPrimitiveTopology ]) ifTrue: [
			baseVertex := vertexCount.
			^ self
		].
		self finishLastPrimitive
	].

	baseVertex := vertexCount.
	primitives add: (WDMeshBuilderPrimitive new
		material: material;
		topology: topology;
		firstIndex: indices size;
		yourself)
]

{ #category : #builder }
WDMeshBuilder >> beginTriangles [
	^ self beginPrimitiveWithTopology: WDPrimitiveTopologyTriangles
]

{ #category : #accessing }
WDMeshBuilder >> colors [

	^ colors
]

{ #category : #private }
WDMeshBuilder >> computeBoundingBoxForPrimitive: builderPrimitive [
	| box |
	box := AABox empty.
	builderPrimitive firstIndex to: builderPrimitive firstIndex + builderPrimitive indexCount - 1 do: [ :i |
		box insertPoint: (self fetchPositionAt: (indices at: i + 1))
	].

	^ box
]

{ #category : #accessing }
WDMeshBuilder >> currentMaterial [
	^ primitives ifEmpty: [ nil ] ifNotEmpty: [ primitives last material ]
]

{ #category : #private }
WDMeshBuilder >> encodeBufferData [
	| encoder encodedAttributes |
	self assert: vertexCount > 0.
	encoder := WDBufferEncoder new.
	
	encodedAttributes := OrderedCollection new.
	buffer := WDBinaryBuffer new.
	vertexBufferView := WDBinaryBufferView new
		buffer: buffer;
		yourself.
	self
		encodeWith: encoder float32Array: positions type: WDBinaryBufferAccessorVector3Type location: WDVertexBufferAttribute positionLocation into: encodedAttributes;
		encodeWith: encoder float32Array: normals type: WDBinaryBufferAccessorVector3Type location: WDVertexBufferAttribute normalLocation into: encodedAttributes;
		encodeWith: encoder float32Array: texcoords0 type: WDBinaryBufferAccessorVector2Type location: WDVertexBufferAttribute texcoord0Location into: encodedAttributes;
		encodeWith: encoder float32Array: texcoords1 type: WDBinaryBufferAccessorVector2Type location: WDVertexBufferAttribute texcoord1Location into: encodedAttributes;
		encodeWith: encoder float32Array: colors type: WDBinaryBufferAccessorVector4Type location: WDVertexBufferAttribute colorLocation into: encodedAttributes;
		encodeWith: encoder float32Array: tangents4 type: WDBinaryBufferAccessorVector4Type location: WDVertexBufferAttribute tangent4Location into: encodedAttributes;
		encodeWith: encoder float32Array: boneWeights type: WDBinaryBufferAccessorVector4Type location: WDVertexBufferAttribute boneWeightsLocation into: encodedAttributes;
		encodeWith: encoder uint16Array: boneIndices type: WDBinaryBufferAccessorVector4Type location: WDVertexBufferAttribute boneIndicesLocation into: encodedAttributes.

	vertexBufferView byteLength: encoder size.

	indexBufferView := WDBinaryBufferView new
		buffer: buffer;
		byteOffset: encoder size;
		yourself.
	vertexCount < 16rffff ifTrue: [
		indexBufferView byteStride: 2.
		encoder addUInt16Array: indices.
	] ifFalse: [ 
		indexBufferView byteStride: 4.
		encoder addUInt32Array: indices.
	].
		
	indexBufferView byteLength: encoder size - indexBufferView byteOffset.
	buffer data: encoder finish.
	vertexBinding := WDVertexBufferBinding new
		attributes: encodedAttributes asArray;
		vertexCount: vertexCount;
		yourself
]

{ #category : #private }
WDMeshBuilder >> encodeWith: encoder float32Array: array type: type location: location into: encodedAttributes [
	| accessor |
	array isEmpty ifTrue: [ ^ self ].
	accessor := WDBinaryBufferAccessor new
		bufferView: vertexBufferView;
		byteOffset: encoder size;
		type: type;
		componentType: WDBinaryBufferAccessorFloat32ComponentType;
		yourself.
	encoder addFloat32Array: array.
	encodedAttributes add: (WDVertexBufferAttribute new
		location: location;
		accessor: accessor;
		yourself)
]

{ #category : #private }
WDMeshBuilder >> encodeWith: encoder uint16Array: array type: type location: location into: encodedAttributes [
	| accessor |
	array isEmpty ifTrue: [ ^ self ].
	accessor := WDBinaryBufferAccessor new
		byteOffset: encoder size;
		type: type;
		componentType: WDBinaryBufferAccessorUInt16ComponentType;
		yourself.
	encoder addUInt16Array: array.
	encodedAttributes add: (WDVertexBufferAttribute new
		location: location;
		accessor: accessor;
		yourself)
]

{ #category : #private }
WDMeshBuilder >> encodedPrimitives [
	^ (primitives collect: [ :each | WDMeshPrimitive new
		topology: each topology;
		material: each material;
		vertexBinding: self vertexBinding;
		indices: (self indexAccessorForPrimitive: each);
		boundingBox: (self computeBoundingBoxForPrimitive: each);
		yourself ]) asArray
]

{ #category : #private }
WDMeshBuilder >> fetchPositionAt: index [
	| baseIndex |
	baseIndex := index * 3.
	^ Vector3 x: (positions at: baseIndex + 1) y: (positions at: baseIndex + 2) z: (positions at: baseIndex + 3)
]

{ #category : #private }
WDMeshBuilder >> finishLastPrimitive [
	| primitive |
	primitives isEmpty ifTrue: [ ^ self ].

	primitive := primitives last.
	primitive indexCount: indices size - primitive firstIndex.
]

{ #category : #private }
WDMeshBuilder >> indexAccessorForPrimitive: builderPrimitive [
	^ WDBinaryBufferAccessor new
		bufferView: indexBufferView;
		byteOffset: builderPrimitive firstIndex * indexBufferView byteStride;
		count: builderPrimitive indexCount;
		type: WDBinaryBufferAccessorScalarType;
		componentType: (indexBufferView byteStride < 4
			ifTrue: [ WDBinaryBufferAccessorUInt16ComponentType ]
			ifFalse: [ WDBinaryBufferAccessorUInt32ComponentType ]);
		yourself
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
	texcoords0 := OrderedCollection new.
	texcoords1 := OrderedCollection new.
	normals := OrderedCollection new.
	tangents4 := OrderedCollection new.
	boneIndices := OrderedCollection new.
	boneWeights := OrderedCollection new.
	indices := OrderedCollection new.
	primitives := OrderedCollection new.
	self reset.
]

{ #category : #builder }
WDMeshBuilder >> mesh [
	(vertexCount <= 0 or: [ indices isEmpty ]) ifTrue: [ ^ WDStaticMeshRenderable new ].
	self finishLastPrimitive.
	
	^ WDStaticMeshRenderable new
		primitives: self encodedPrimitives;
		computeBoundingBoxFromPrimitives;
		yourself
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
	texcoords0 removeAll.
	texcoords1 removeAll.
	normals removeAll.
	indices removeAll.
	primitives removeAll.
	tangents4 removeAll.
	boneIndices removeAll.
	boneWeights removeAll.
	vertexCount := 0.
	baseVertex := 0.

]

{ #category : #accessing }
WDMeshBuilder >> texcoords0 [

	^ texcoords0
]

{ #category : #accessing }
WDMeshBuilder >> texcoords1 [
	^ texcoords1
]

{ #category : #private }
WDMeshBuilder >> vertexBinding [
	vertexBinding ifNil: [ self encodeBufferData ].
	^ vertexBinding
]

{ #category : #accessing }
WDMeshBuilder >> vertexCount [
	^ vertexCount
]
