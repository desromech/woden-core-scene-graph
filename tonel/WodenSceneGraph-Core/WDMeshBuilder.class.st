"
I am an utilty for building renderable meshes.
"
Class {
	#name : #WDMeshBuilder,
	#superclass : #Object,
	#instVars : [
		'positions',
		'colors',
		'texcoords',
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
		'indexBufferView'
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

{ #category : #builder }
WDMeshBuilder >> beginPrimitiveWithTopology: topology [
	^ self beginPrimitiveWithTopology: topology material: self currentMaterial
]

{ #category : #builder }
WDMeshBuilder >> beginPrimitiveWithTopology: topology material: material [

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

{ #category : #accessing }
WDMeshBuilder >> currentMaterial [
	^ primitives ifEmpty: [ nil ] ifNotEmpty: [ primitives last material ]
]

{ #category : #'as yet unclassified' }
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
		encodeWith: encoder float32Array: texcoords type: WDBinaryBufferAccessorVector2Type location: WDVertexBufferAttribute texcoordLocation into: encodedAttributes;
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
WDMeshBuilder >> encodedPrimitives [
	^ (primitives collect: [ :each | WDMeshPrimitive new
		topology: each topology;
		material: each material;
		vertexBinding: self vertexBinding;
		indices: (self indexAccessorForPrimitive: each);
		yourself ]) asArray
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> finishLastPrimitive [
	| primitive |
	primitives isEmpty ifTrue: [ ^ self ].

	primitive := primitives last.
	primitive indexCount: indices size - primitive firstIndex.
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> indexAccessorForPrimitive: builderPrimitives [
	^ WDBinaryBufferAccessor new
		bufferView: indexBufferView;
		byteOffset: builderPrimitives firstIndex * indexBufferView byteStride;
		count: builderPrimitives indexCount;
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
	texcoords := OrderedCollection new.
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
		primitives: (self encodedPrimitives);
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
	texcoords removeAll.
	normals removeAll.
	indices removeAll.
	primitives removeAll.
	tangents4 removeAll.
	boneIndices removeAll.
	boneWeights removeAll.
	vertexCount := 0.

]

{ #category : #accessing }
WDMeshBuilder >> texcoords [

	^ texcoords
]

{ #category : #'as yet unclassified' }
WDMeshBuilder >> vertexBinding [
	vertexBinding ifNil: [ self encodeBufferData ].
	^ vertexBinding
]

{ #category : #accessing }
WDMeshBuilder >> vertexCount [
	^ vertexCount
]
