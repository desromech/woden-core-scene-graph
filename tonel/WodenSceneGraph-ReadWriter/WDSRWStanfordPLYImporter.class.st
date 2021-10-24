"
I am importer for models in the Standford PLY format.

https://en.wikipedia.org/wiki/PLY_(file_format)

"
Class {
	#name : #WDSRWStanfordPLYImporter,
	#superclass : #Object,
	#instVars : [
		'elements',
		'elementDictionary',
		'currentElement'
	],
	#classVars : [
		'CommandDictionary'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-ReadWriter-PLY'
}

{ #category : #accessing }
WDSRWStanfordPLYImporter class >> extension [
	^ 'ply'
]

{ #category : #initialization }
WDSRWStanfordPLYImporter class >> initialize [
	super initialize.
	
	CommandDictionary := Dictionary new.
	
	{
		#comment . [ :myself :argument | ].
		#element . [ :myself :arguments | myself beginElement: arguments ].
		#property . [ :myself :arguments | myself parseProperty: arguments].
	} pairsDo: [ :command :action |
		CommandDictionary at: command put: action
	]
]

{ #category : #documentation }
WDSRWStanfordPLYImporter class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> addTriangleI1: i1 i2: i2 i3: i3 into: indices [
	indices
		add: i1;
		add: i2;
		add: i3
]

{ #category : #'header parsing' }
WDSRWStanfordPLYImporter >> beginElement: arguments [
	| name count |
	name := arguments second.
	count := arguments third asInteger.
	currentElement := WDSRWStanfordPLYElement new
		name: name;
		count: count;
		yourself.
		
	elements add: currentElement.
	elementDictionary at: name put: currentElement
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> extractIndices [
	| faceElement indexOfFaceIndices indexList indices |
	indices := OrderedCollection new.
	
	faceElement := elementDictionary at: #face.
	indexOfFaceIndices := faceElement indexOfProperty: #vertex_indices.
	faceElement values do: [ :faceValue |
		indexList := faceValue at: indexOfFaceIndices.
		self triangulateFace: indexList into: indices
	].

	^ indices
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> extractPositions [
	| vertexElement positions values xi yi zi x y z vertexValue |
	vertexElement := elementDictionary at: 'vertex'.
	positions := OrderedCollection new: vertexElement count*3.
	values := vertexElement values.
	xi := vertexElement indexOfProperty: #x.
	yi := vertexElement indexOfProperty: #y.
	zi := vertexElement indexOfProperty: #z.
	
	1 to: vertexElement count do: [ :index |
		vertexValue := values at: index.
		x := vertexValue at: xi.
		y := vertexValue at: yi.
		z := vertexValue at: zi.
		
		positions add: x; add: y; add: z
	].

	^ positions
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> finishLoading [
	| positions indices boundingBox primitive vertexCount encoder buffer vertexBufferView vertexBinding positionsAccessor indexBufferView indicesAccessor mesh |
	positions := self extractPositions.
	indices := self extractIndices.
	
	(positions isEmpty or: [ indices isEmpty ]) ifTrue: [ ^ WDModelAsset new ].
	
	boundingBox := AABox empty.
	1 to: positions size // 3 do: [ :i |
		boundingBox insertPoint: (Vector3 x: (positions at: i*3 - 2) y: (positions at: i*3 - 1) z: (positions at: i*3))
	].

	vertexCount := positions size // 3.
	encoder := WDBufferEncoder new.
	buffer := WDBinaryBuffer new.
	vertexBufferView := WDBinaryBufferView new
		buffer: buffer;
		yourself.
	vertexBinding := WDVertexBufferBinding new
		vertexCount: vertexCount;
		yourself.
		
	positionsAccessor := WDBinaryBufferAccessor new
		bufferView: vertexBufferView;
		byteOffset: encoder size;
		count: vertexCount;
		type: WDBinaryBufferAccessorVector3Type;
		componentType: WDBinaryBufferAccessorFloat32ComponentType;
		yourself.
	encoder addFloat32Array: positions.
	vertexBinding attributes: {WDVertexBufferAttribute new
		location: WDVertexBufferAttribute positionLocation;
		accessor: positionsAccessor;
		yourself}.
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

	indicesAccessor := WDBinaryBufferAccessor new
		bufferView: indexBufferView;
		byteOffset: 0;
		count: indices size;
		type: WDBinaryBufferAccessorScalarType;
		componentType: (indexBufferView byteStride < 4
			ifTrue: [ WDBinaryBufferAccessorUInt16ComponentType ]
			ifFalse: [ WDBinaryBufferAccessorUInt32ComponentType ]);
		yourself.

	primitive := WDMeshPrimitive new
		indices: indicesAccessor;
		vertexBinding: vertexBinding;
		topology: WDPrimitiveTopologyTriangles;
		boundingBox: boundingBox;
		yourself.
	mesh := WDStaticMeshRenderable new
		boundingBox: boundingBox;
		primitives: { primitive };
		yourself.
	^ WDModelAsset new
		addMesh: mesh;
		yourself
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> initializeLoading [
	elements := OrderedCollection new.
	elementDictionary := Dictionary new.
]

{ #category : #'content parsing' }
WDSRWStanfordPLYImporter >> parseContentWith: tokenReader [
	elements do: [ :element | self parseElementContent: element with: tokenReader ]
]

{ #category : #'content parsing' }
WDSRWStanfordPLYImporter >> parseElementContent: element with: tokenReader [
	| values properties |
	properties := element properties asArray.
	values := (1 to: element count) collect: [ :i |
		properties collect: [ :property | property readFrom: tokenReader ].
	].

	element values: values
]

{ #category : #'header parsing' }
WDSRWStanfordPLYImporter >> parseHeaderWith: lineReader [
	| line arguments |
	lineReader nextLine ~= 'ply' ifTrue: [ self error: 'Expected ply header' ].
	lineReader nextLine ~= 'format ascii 1.0' ifTrue: [ self error: 'Only ASCII ply format is supported.' ].
	
	[ lineReader atEnd ] whileFalse: [ 
		line := lineReader nextLine.
		line = 'end_header' ifTrue: [ ^ self ].
		
		arguments := line splitOn: ' '.
		(CommandDictionary at: arguments first) value: self value: arguments
	]

]

{ #category : #loading }
WDSRWStanfordPLYImporter >> parseLinesWith: lineReader [
	self
		parseHeaderWith: lineReader;
		parseContentWith: lineReader asSpaceTokenReader
]

{ #category : #'header parsing' }
WDSRWStanfordPLYImporter >> parseProperty: arguments [
	| type name property |
	type := arguments second.
	type = 'list' ifTrue: [ ^ self parsePropertyList: arguments ].

	name := arguments third.
	property := (WDSRWStanfordPLYProperty findPropertyClassFromType: type) new name: name.
	currentElement addProperty: property
	
]

{ #category : #'header parsing' }
WDSRWStanfordPLYImporter >> parsePropertyList: arguments [
	| countType elementType name property |
	countType := WDSRWStanfordPLYProperty findPropertyClassFromType: arguments third.
	elementType := WDSRWStanfordPLYProperty findPropertyClassFromType: arguments fourth.
	name := arguments fifth.
	
	property := WDSRWStanfordPLYPropertyList new name: name;
		countType: countType new;
		elementType: elementType new;
		yourself.
	currentElement addProperty: property
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> readFromFileReference: fileRef [
	^ fileRef readStreamDo: [ :fin |
		self initializeLoading;
			parseLinesWith: (WDSRWLineReader on: fin);
			finishLoading
	]
]

{ #category : #loading }
WDSRWStanfordPLYImporter >> triangulateFace: faceIndices into: indices [
	3 to: faceIndices size do: [ :i |
		self addTriangleI1: faceIndices first i2: (faceIndices at: i - 1) i3: (faceIndices at: i) into: indices
	]
]
