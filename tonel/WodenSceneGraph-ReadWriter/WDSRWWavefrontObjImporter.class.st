"
I am an importer for wavefront .obj 3d models.
"
Class {
	#name : 'WDSRWWavefrontObjImporter',
	#superclass : 'Object',
	#instVars : [
		'currentDirectory',
		'materialLibrary',
		'currentObjectName',
		'positions',
		'normals',
		'texcoords',
		'indices',
		'concreteVertexDictionary',
		'submeshes',
		'currentMaterial',
		'rawPositions',
		'rawTexcoords',
		'rawNormals',
		'vertexBufferView',
		'indexBufferView'
	],
	#classVars : [
		'CommandDictionary'
	],
	#category : 'WodenSceneGraph-ReadWriter-OBJ',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'OBJ'
}

{ #category : 'initialization' }
WDSRWWavefrontObjImporter class >> initialize [
	super initialize.
	CommandDictionary := Dictionary newFromPairs: {
		#mtllib . [ :myself :arguments | myself useMaterialLibrary: arguments second ].
		#usemtl . [ :myself :arguments | myself useMaterial: arguments second ].
		#o . [ :myself :arguments | myself beginObject: arguments second ].
		#v . [ :myself :arguments | myself parsePosition: arguments ].
		#vt . [ :myself :arguments | myself parseTexcoord: arguments ].
		#vn . [ :myself :arguments | myself parseNormal: arguments ].
		#f . [ :myself :arguments | myself parseFace: arguments ].
		#l . [ :myself :arguments | myself parseLine: arguments ].
	}
]

{ #category : 'documentation' }
WDSRWWavefrontObjImporter class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> addTriangleI1: i1 i2: i2 i3: i3 [
	self beginTriangles.
	indices
		add: i1;
		add: i2;
		add: i3
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> beginLines [
	self beginSubmesh: WDPrimitiveTopologyLines
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> beginObject: objectName [
	currentObjectName := objectName
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> beginSubmesh: topology [
	| submesh |
	submeshes ifNotEmpty: [
		(submeshes last topology = topology asPrimitiveTopology and: [ submeshes last material == currentMaterial ]) ifTrue: [ ^ self ].
	].

	self finishCurrentSubmesh.
	submesh := WDMeshPrimitive new
		indices: (WDBinaryBufferAccessor new
			byteOffset: indices size;
			count: 0;
			yourself
		);
		topology: topology;
		material: currentMaterial;
		yourself.
	submeshes add: submesh.
	
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> beginTriangles [
	self beginSubmesh: WDPrimitiveTopologyTriangles
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> buildFaceWithIndices: faceIndices [
	3 to: faceIndices size do: [ :i |
		self addTriangleI1: faceIndices first i2: (faceIndices at: i - 1) i3: (faceIndices at: i)
	]
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> concretizeVertex: vertexTopology faceNormal: faceNormal [
	| position texcoord normal nextIndex |
	position := self fetchRawPosition: vertexTopology first.
	texcoord := vertexTopology second
		ifNil: [Vector2 zeros]
		ifNotNil: [:index | self fetchRawTexcoord: index].
	normal := vertexTopology third
		ifNil: [faceNormal ]
		ifNotNil: [:index | self fetchRawNormals: index].
	
	^ concreteVertexDictionary at: { position . texcoord . normal } ifAbsentPut: [
		nextIndex := positions size // 3.
		positions add: position x; add: position y; add: position z.
		texcoords add: texcoord x; add: texcoord y.
		normals add: normal x; add: normal y; add: normal z.
		nextIndex
	]
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontObjImporter >> encodeBuffers [
	| vertexCount encoder encodedAttributes buffer vertexBinding |
	self assert: (positions size // 3) = (texcoords size // 2).
	self assert: (texcoords size // 2) = (normals size // 3).
	vertexCount := positions size.
	encoder := WDBufferEncoder new.

	encodedAttributes := OrderedCollection new.
	buffer := WDBinaryBuffer new.
	vertexBufferView := WDBinaryBufferView new
		buffer: buffer;
		yourself.
	self
		encodeWith: encoder float32Array: positions type: WDBinaryBufferAccessorVector3Type location: WDVertexBufferAttribute positionLocation into: encodedAttributes;
		encodeWith: encoder float32Array: normals type: WDBinaryBufferAccessorVector3Type location: WDVertexBufferAttribute normalLocation into: encodedAttributes;
		encodeWith: encoder float32Array: texcoords type: WDBinaryBufferAccessorVector2Type location: WDVertexBufferAttribute texcoord0Location into: encodedAttributes.
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
		yourself.
		
	submeshes do: [ :submesh |
		submesh indices
			bufferView: indexBufferView;
			byteOffset: submesh indices byteOffset * indexBufferView byteStride;
			type: WDBinaryBufferAccessorScalarType;
			componentType: (indexBufferView byteStride < 4
				ifTrue: [ WDBinaryBufferAccessorUInt16ComponentType ]
				ifFalse: [ WDBinaryBufferAccessorUInt32ComponentType ]).
		submesh vertexBinding: vertexBinding
	]
]

{ #category : 'private' }
WDSRWWavefrontObjImporter >> encodeWith: encoder float32Array: array type: type location: location into: encodedAttributes [
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

{ #category : 'as yet unclassified' }
WDSRWWavefrontObjImporter >> fetchPosition: index [
	^ Vector3 x: (positions at: index*3 - 2) y: (positions at: index*3 - 1) z: (positions at: index*3)
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontObjImporter >> fetchRawNormals: index [
	^ Vector3 x: (rawNormals at: index*3 - 2) y: (rawNormals at: index*3 - 1) z: (rawNormals at: index*3)
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontObjImporter >> fetchRawPosition: index [
	^ Vector3 x: (rawPositions at: index*3 - 2) y: (rawPositions at: index*3 - 1) z: (rawPositions at: index*3)
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontObjImporter >> fetchRawTexcoord: index [
	^ Vector2 x: (rawTexcoords at: index*2 - 1) y: (rawTexcoords at: index*2)
]

{ #category : 'submesh building' }
WDSRWWavefrontObjImporter >> finishCurrentSubmesh [
	| submesh boundingBox firstIndex count |
	submeshes ifEmpty: [ ^ self ].
	submesh := submeshes last.
	firstIndex := submesh indices byteOffset.
	count := indices size - firstIndex.
	submesh indices count: count.
	boundingBox := AABox empty.
	firstIndex + 1 to: firstIndex + count do: [ :i |
		boundingBox insertPoint: (self fetchPosition: (indices at: i) + 1)
	].
	submesh boundingBox: boundingBox
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> finishLoading [
	| boundingBox mesh |
	self finishCurrentSubmesh.
	self encodeBuffers.
	
	boundingBox := AABox empty.
	submeshes do: [ :sm |
		boundingBox insertBox: sm boundingBox
	].
	mesh := WDStaticMeshRenderable new
		primitives: submeshes asArray;
		boundingBox: boundingBox;
		yourself.
		
	^ WDModelAsset new
		addElementWithDependencies: mesh;
		yourself
]

{ #category : 'initialization' }
WDSRWWavefrontObjImporter >> initializeLoading [
	rawPositions := OrderedCollection new.
	rawNormals := OrderedCollection new.
	rawTexcoords := OrderedCollection new.

	positions := OrderedCollection new.
	normals := OrderedCollection new.
	texcoords := OrderedCollection new.
	
	indices := OrderedCollection new.
	
	concreteVertexDictionary := Dictionary new.
	submeshes := OrderedCollection new.
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseFace: components [
	| topologies p1 p2 p3 u v n |
	topologies := components allButFirst collect: [ :vertex |
		self parseFaceVertex: vertex
	].

	p1 := self fetchRawPosition: topologies first first.
	p2 := self fetchRawPosition: topologies second first.
	p3 := self fetchRawPosition: topologies third first.
	
	u := p2 - p1.
	v := p3 - p1.
	n := (u cross: v) normalized.

	self buildFaceWithIndices: (topologies collect: [ :topo | self concretizeVertex: topo faceNormal: n])
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseFaceElement: faceElement [
	^ faceElement ifEmpty: [ nil ] ifNotEmpty: [ faceElement asInteger ]
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseFaceVertex: encodedFace [
	| parts |
	parts := (encodedFace splitOn: '/') collect: [ :part | self parseFaceElement: part ].
	parts size = 1 ifTrue: [ ^ parts , #(nil nil) ].
	parts size = 2 ifTrue: [ ^ parts , #(nil) ].
	^ parts
	
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseLine: line [
	| components command |
	line ifEmpty: [ ^ self ].
	line first = $# ifTrue: [ ^ self ].
	
	components := line substrings.
	command := components first.
	(CommandDictionary at: command ifAbsent: [ ^ self ]) value: self value: components
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseLinesWith: lineReader [
	[lineReader atEnd] whileFalse: [
		self parseLine: lineReader nextLine
	].

]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseNormal: components [
	rawNormals
		add: components second asNumber;
		add: components third asNumber;
		add: components fourth asNumber
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parsePosition: components [
	rawPositions
		add: components second asNumber;
		add: components third asNumber;
		add: components fourth asNumber.
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> parseTexcoord: components [
	rawTexcoords
		add: components second asNumber;
		add: 1.0 - components third asNumber
]

{ #category : 'loading' }
WDSRWWavefrontObjImporter >> readFromFileReference: fileRef [
	currentDirectory := fileRef parent.
	^ fileRef readStreamDo: [ :fin |
		self initializeLoading;
			parseLinesWith: (WDSRWLineReader on: fin);
			finishLoading
	]
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> useMaterial: materialName [
	| newMaterial |
	newMaterial := materialLibrary ifNotNil: [ :lib | materialLibrary at: materialName ifAbsent: [ nil ] ].
	currentMaterial ~= newMaterial ifTrue: [ 
		self finishCurrentSubmesh.
		currentMaterial := newMaterial
	]
	
]

{ #category : 'parsing' }
WDSRWWavefrontObjImporter >> useMaterialLibrary: fileName [
	materialLibrary := WDSRWWavefrontMTLImporter loadFromFile: (currentDirectory resolve: fileName asFileReference)
]
