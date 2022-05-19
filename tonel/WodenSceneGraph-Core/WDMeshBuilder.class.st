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
		'baseVertex',
		'currentMaterial',
		'currentTransform'
	],
	#classVars : [
		'CubeSphereBaseLevelQuads',
		'NormalAxis'
	],
	#category : #'WodenSceneGraph-Core-RenderableBuilder'
}

{ #category : #initialization }
WDMeshBuilder class >> initialize [
	NormalAxis := { 
		Vector3 x: 1 y: 0 z: 0.
		Vector3 x: -1 y: 0 z: 0 .
		Vector3 x: 0 y: 1 z: 0.
		Vector3 x: 0 y: -1 z: 0 .
		Vector3 x: 0 y: 0 z: 1 .
		Vector3 x: 0 y: 0 z: -1 .
	}.
	
	CubeSphereBaseLevelQuads := { 
		{
			Vector3 x: -1 y: -1 z: -1. 
			Vector3 x: -1 y: -1 z: 1. 
			Vector3 x: -1 y: 1 z: 1. 
			Vector3 x: -1 y: 1 z: -1.
		}.

		{
			Vector3 x: 1 y: 1 z: -1. 
			Vector3 x: 1 y: 1 z: 1. 
			Vector3 x: 1 y: -1 z: 1. 
			Vector3 x: 1 y: -1 z: -1.
		}.

		{
			Vector3 x: 1 y: -1  z: -1. 
			Vector3 x: 1 y: -1 z: 1. 
			Vector3 x: -1 y: -1 z: 1. 
			Vector3 x: -1 y: -1 z: -1.
		}.

		{
			Vector3 x: -1 y: 1 z: -1. 
			Vector3 x: -1 y: 1 z: 1. 
			Vector3 x: 1 y: 1 z: 1. 
			Vector3 x: 1 y: 1 z: -1.
		}.

		{
			Vector3 x: 1 y: 1 z: -1. 
			Vector3 x: 1 y: -1 z: -1. 
			Vector3 x: -1 y: -1 z: -1. 
			Vector3 x: -1 y: 1 z: -1.
		}.

		{
			Vector3 x: -1 y: 1 z: 1. 
			Vector3 x: -1 y: -1 z: 1. 
			Vector3 x: 1 y: -1 z: 1. 
			Vector3 x: 1 y: 1 z: 1.
		}.
	}.
]

{ #category : #adding }
WDMeshBuilder >> addColor: color [
	| v4 |
	v4 := color asVector4.
	self addCr: v4 x g: v4 y b: v4 z a: v4 w
]

{ #category : #adding }
WDMeshBuilder >> addConeWithRadius: radius halfDepth: halfDepth segments: segments [
	self beginTriangles.
	self addP: Vector3 zeros; addN: (Vector3 z: 1).
	
	(0 to: segments - 1) do: [ :segment |
		| theta x y z position normal |
		theta := (Float twoPi * segment) / (segments - 1) - Float halfPi.
		x := theta cos.
		y := theta sin.
		z := halfDepth negated.

		position := Vector3 x: x * radius y: y * radius z: z.
		normal := (Vector3 x: x y: y z: 0) normalized.
		self addP: position; addN: normal.		
	].

	"Add the triangles"
	(0 to: segments - 1) do: [ :segment |
		self addTriangleI0: 0 i1: segment + 1 i2: (segment + 1) % segments + 1
	].

]

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
WDMeshBuilder >> addCubeSphereWithRadius: radius subdivisions: subdivisions [
	self privateAddCubeSphereWithRadius: radius subdivisions: subdivisions quads: CubeSphereBaseLevelQuads
]

{ #category : #adding }
WDMeshBuilder >> addCubeWithHalfExtent: halfExtent [
	self addCubeMinX: halfExtent x negated y: halfExtent y negated z: halfExtent z negated
		maxX: halfExtent x y: halfExtent y z: halfExtent z
]

{ #category : #adding }
WDMeshBuilder >> addCubeWithWidth: width height: height depth: depth [
	| halfWidth halfHeight halfDepth |
	halfWidth := width / 2.
	halfHeight := height / 2.
	halfDepth := depth / 2.
	self addCubeMinX: halfWidth negated y: halfHeight negated z: halfDepth negated maxX: halfWidth y: halfHeight z: halfDepth
]

{ #category : #adding }
WDMeshBuilder >> addInteriorCubeMinX: minX y: minY z: minZ maxX: maxX y: maxY z: maxZ [
	self
		"Left"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: minX y: maxY z: minZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: minX y: maxY z: maxZ; addNx: 1.0 y: 0.0 z: 0.0;
		addPx: minX y: minY z: maxZ; addNx: 1.0 y: 0.0 z: 0.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0;

		"Right"
		beginTriangles;
		addPx: maxX y: minY z: minZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: maxX y: maxY z: minZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: maxX y: maxY z: maxZ; addNx: -1.0 y: 0.0 z: 0.0;
		addPx: maxX y: minY z: maxZ; addNx: -1.0 y: 0.0 z: 0.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0;

		"Top"
		beginTriangles;
		addPx: minX y: maxY z: minZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: maxX y: maxY z: minZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: maxX y: maxY z: maxZ; addNx: 0.0 y: -1.0 z: 0.0;
		addPx: minX y: maxY z: maxZ; addNx: 0.0 y: -1.0 z: 0.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0;

		"Bottom"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: minY z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: minY z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: minX y: minY z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0;

		"Back"
		beginTriangles;
		addPx: minX y: minY z: minZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: maxX y: minY z: minZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: maxX y: maxY z: minZ; addNx: 0.0 y: 0.0 z: 1.0;
		addPx: minX y: maxY z: minZ; addNx: 0.0 y: 0.0 z: 1.0;
		addTriangleI0: 0 i1: 1 i2: 2;
		addTriangleI0: 2 i1: 3 i2: 0;

		"Front"
		beginTriangles;
		addPx: minX y: minY z: maxZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: maxX y: minY z: maxZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: maxX y: maxY z: maxZ; addNx: 0.0 y: 0.0 z: -1.0;
		addPx: minX y: maxY z: maxZ; addNx: 0.0 y: 0.0 z: -1.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0
]

{ #category : #adding }
WDMeshBuilder >> addInteriorCubeWithWidth: width height: height depth: depth [
	| halfWidth halfHeight halfDepth |
	halfWidth := width / 2.
	halfHeight := height / 2.
	halfDepth := depth / 2.
	self addInteriorCubeMinX: halfWidth negated y: halfHeight negated z: halfDepth negated maxX: halfWidth y: halfHeight z: halfDepth
]

{ #category : #adding }
WDMeshBuilder >> addLineGridWithWidth: width height: height subdivisions: subdivisions [
	| dx dy x y px py nx ny tc  |
	
	"Add vertices"
	dx := width / (subdivisions - 1).
	dy := height / (subdivisions - 1).
	px := width / 2.
	py := height / 2.
	nx := px negated.
	ny := py negated.
	x := nx.
	
	"Vertical lines"
	self beginLines.
	0 to: subdivisions - 1 do: [:i |
		self addPx: x y: ny z: 0.
		self addPx: x y: py z: 0.
		self addLineI0: i*2 i1: i*2 + 1.
		x := x + dx.
	].

	"Horizontal lines"
	self beginLines.
	y := ny.
	0 to: subdivisions - 1 do: [:i |
		self addPx: nx y: y z: 0.
		self addPx: px y: y z: 0.
		self addLineI0: i*2 i1: i*2 + 1.
		y := y + dy.
	].

]

{ #category : #adding }
WDMeshBuilder >> addLineI0: i0 i1: i1 [
	indices add: i0 + baseVertex ; add: i1 + baseVertex
]

{ #category : #adding }
WDMeshBuilder >> addN: normal [
	| transformedNormal |
	transformedNormal := (currentTransform transformNormalVector: normal) normalized.
	normals add: transformedNormal x; add: transformedNormal y; add: transformedNormal z.
]

{ #category : #adding }
WDMeshBuilder >> addNx: x y: y z: z [
	self addN: (Vector3 x: x y: y z: z)
]

{ #category : #adding }
WDMeshBuilder >> addP: position [
	| transformedPosition |
	transformedPosition := currentTransform transformPosition: position. 
	positions add: transformedPosition x; add: transformedPosition y; add: transformedPosition z.
	vertexCount := vertexCount + 1.
]

{ #category : #adding }
WDMeshBuilder >> addPlaneMinX: minX z: minZ maxX: maxX z: maxZ [
	self
		"Top"
		beginTriangles;
		addPx: minX y: 0 z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: 0 z: minZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: maxX y: 0 z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addPx: minX y: 0 z: maxZ; addNx: 0.0 y: 1.0 z: 0.0;
		addTriangleI0: 1 i1: 0 i2: 2;
		addTriangleI0: 3 i1: 2 i2: 0
]

{ #category : #adding }
WDMeshBuilder >> addPlaneWithWidth: width height: height [
	| halfWidth halfHeight |
	halfWidth := width / 2.
	halfHeight := height / 2.
	self addPlaneMinX: halfWidth negated z: halfHeight negated maxX: halfWidth z: halfHeight
]

{ #category : #adding }
WDMeshBuilder >> addPx: x y: y z: z [
	self addP: (Vector3 x: x y: y z: z)
]

{ #category : #adding }
WDMeshBuilder >> addQuadI0: i0 i1: i1 i2: i2 i3: i3 [ 
	indices
		add: i0 + baseVertex ; add: i1 + baseVertex; add: i2 + baseVertex;
		add: i2 + baseVertex ; add: i3 + baseVertex; add: i0 + baseVertex
]

{ #category : #adding }
WDMeshBuilder >> addQuadIndices: quadIndices [
	indices
		add: quadIndices first + baseVertex ; add: quadIndices second + baseVertex; add: quadIndices third + baseVertex;
		add: quadIndices third + baseVertex ; add: quadIndices fourth + baseVertex; add: quadIndices first + baseVertex
]

{ #category : #adding }
WDMeshBuilder >> addT0: tc [
	texcoords0 add: tc x; add: tc y
]

{ #category : #adding }
WDMeshBuilder >> addT0u: u v: v [
	texcoords0 add: u; add: v
]

{ #category : #adding }
WDMeshBuilder >> addT1: tc [
	texcoords1 add: tc x; add: tc y
]

{ #category : #adding }
WDMeshBuilder >> addT1u: u v: v [
	texcoords1 add: u; add: v
]

{ #category : #adding }
WDMeshBuilder >> addTriangleI0: i0 i1: i1 i2: i2 [
	indices add: i0 + baseVertex ; add: i1 + baseVertex; add: i2 + baseVertex
]

{ #category : #adding }
WDMeshBuilder >> addUVEllipsoidWithDiameters: diameters segments: segments slices: slices [
	self addUVEllipsoidWithRadiuses: diameters / 2 segments: segments slices: slices
]

{ #category : #adding }
WDMeshBuilder >> addUVEllipsoidWithRadiuses: radiuses segments: segments slices: slices [
	self beginTriangles.

	"Add the vertices"
	(0 to: segments - 1) do: [ :segment |
		| theta |
		theta := (Float pi * segment) / (segments - 1) - Float halfPi.
		
		(0 to: slices - 1) do: [ :slice |
			| phi x y z position normal |
			phi := (Float twoPi  * slice) / (slices - 1) - Float pi.
			x := (phi cos) * (theta cos).
			y := theta sin.
			z := (phi sin) * (theta cos).
			position := Vector3 x: x * radiuses x y: y * radiuses y z: z * radiuses z.
			normal := position normalized.
			self addP: position; addN: normal.
		].
	].

	"Add the quads"
	(0 to: segments - 2) do: [ :segment |
		| firstRow secondRow |
		firstRow := segment*slices.
		secondRow := (segment+1)*slices.
		(0 to: slices - 1) do: [ :slice |
			| firstSlice secondSlice |
			firstSlice := slice.
			secondSlice := (slice + 1) % slices.
			self addQuadI0: firstRow + secondSlice i1: firstRow+firstSlice i2: secondRow+firstSlice i3: secondRow+secondSlice
		]
	].

]

{ #category : #adding }
WDMeshBuilder >> addUVSphereWithDiameter: diameter segments: segments slices: slices [
	self addUVEllipsoidWithRadiuses: (diameter / 2) asVector3 segments: segments slices: slices
]

{ #category : #adding }
WDMeshBuilder >> addUVSphereWithRadius: radius segments: segments slices: slices [
	self addUVEllipsoidWithRadiuses: radius asVector3 segments: segments slices: slices
]

{ #category : #builder }
WDMeshBuilder >> beginLines [
	^ self beginPrimitiveWithTopology: WDPrimitiveTopologyLines
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

{ #category : #private }
WDMeshBuilder >> bitangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 3) rem: NormalAxis size) + 1
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

{ #category : #private }
WDMeshBuilder >> computeNormalAxis: normal [
	| amount bestAmount best |
	bestAmount := Float negativeInfinity.
	best := -1.
	1 to: NormalAxis size do: [ :i |
		amount := normal dot: (NormalAxis at: i).
		amount > bestAmount ifTrue: [
			bestAmount := amount.
			best := i.
		]
	].

	best < 1 ifTrue: [ self error: 'Using invalid normal.' ].
	^ best

]

{ #category : #accessing }
WDMeshBuilder >> currentMaterial [
	^ currentMaterial
]

{ #category : #accessing }
WDMeshBuilder >> currentMaterial: aMaterial [
	currentMaterial := aMaterial
]

{ #category : #private }
WDMeshBuilder >> decodeNormals [
	| sourceIndex |
	sourceIndex := -2.
	^ (1 to: vertexCount) collect: [ :i |
		sourceIndex := sourceIndex + 3.
		Vector3 x: (normals at: sourceIndex) y: (normals at: sourceIndex + 1) z: (normals at: sourceIndex + 2)
	]
]

{ #category : #private }
WDMeshBuilder >> decodePositions [
	| sourceIndex |
	sourceIndex := -2.
	^ (1 to: vertexCount) collect: [ :i |
		sourceIndex := sourceIndex + 3.
		Vector3 x: (positions at: sourceIndex) y: (positions at: sourceIndex + 1) z: (positions at: sourceIndex + 2)
	]
]

{ #category : #private }
WDMeshBuilder >> decodeTexcoords0 [
	| sourceIndex |
	sourceIndex := -1.
	^ (1 to: vertexCount) collect: [ :i |
		sourceIndex := sourceIndex + 2.
		Vector2 x: (texcoords0 at: sourceIndex) y: (texcoords0 at: sourceIndex + 1)
	]
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

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTangentSpaceFrame [
	| tangents bitangents decodedPositions decodedNormals decodedTexcoords0 |
	self assert: self hasValidPositions.
	self assert: self hasValidNormals.
	self assert: self hasValidTexcoords0.
	self finishLastPrimitive.
	
	decodedPositions := self decodePositions.
	decodedTexcoords0 := self decodeTexcoords0.
	decodedNormals := self decodeNormals.
	tangents := Array new: vertexCount withAll: Vector3 zeros.
	bitangents := Array new: vertexCount withAll: Vector3 zeros.
	
	primitives do: [ :eachPrimitive |
		eachPrimitive topology triangleIndicesWithBase: eachPrimitive firstIndex + 1 count: eachPrimitive indexCount do: [ :i0 :i1 :i2 |
			| vi0 vi1 vi2 p0 p1 p2 tc0 tc1 tc2 u v du0 du1 dv0 dv1 det |
			vi0 := (indices at: i0) + 1.
			vi1 := (indices at: i1) + 1.
			vi2 := (indices at: i2) + 1.
			
			p0 := decodedPositions at: vi0.
			p1 := decodedPositions at: vi1.
			p2 := decodedPositions at: vi2.

			tc0 := decodedTexcoords0 at: vi0.
			tc1 := decodedTexcoords0 at: vi1.
			tc2 := decodedTexcoords0 at: vi2.

			u := p1 - p0.
			v := p2 - p0.
			
			du0 := tc1 x - tc0 x.
			dv0 := tc1 y - tc0 y.
			
			du1 := tc2 x - tc0 x.
			dv1 := tc2 y - tc0 y.
			
			det := (du0*dv1) - (du1*dv0).
			(det closeTo: 0) ifFalse: [
				| den tangent bitangent |
				den := 1.0 / det.
				
				tangent := (u * (den*dv1))  - (v * (den*dv0)).
				bitangent := (v * (den*du0)) - (u * (den*du1)).
				
				tangents at: vi0 put: (tangents at: vi0) + tangent.
				tangents at: vi1 put: (tangents at: vi1) + tangent.
				tangents at: vi2 put: (tangents at: vi2) + tangent.

				bitangents at: vi0 put: (bitangents at: vi0) + bitangent.
				bitangents at: vi1 put: (bitangents at: vi1) + bitangent.
				bitangents at: vi2 put: (bitangents at: vi2) + bitangent.
			].
		]
	].
	
	tangents4 := OrderedCollection new: vertexCount * 4.
	1 to: vertexCount do: [ :i |
		| t b n s |
		t := tangents at: i. 
		b := bitangents at: i. 
		n := decodedNormals at: i. 
		
		"Gram schmidth orthogonalization"
		t := (t - (n * (n dot: t))) normalized.
		b := (b - (n * (n dot: b)) - (t * (t dot: b))) normalized.
		s := (n cross: t) dot: b.
		
		tangents4
			add: t x; add: t y; add: t z; add: s
	].

]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithFacePlanarTransform: transformMatrix [
	| sourceIndex |
	self assert: self hasValidPositions.
	self assert: self hasValidNormals.
	texcoords0 := OrderedCollection new: vertexCount * 2.
	sourceIndex := 1.
	1 to: vertexCount do: [ :i |
		| position normal normalAxis tangent bitangent uv transformedUV |
		"Fetch the position and normal"
		position := Vector3 x: (positions at: sourceIndex) y: (positions at: sourceIndex + 1) z: (positions at: sourceIndex + 2).
		normal := Vector3 x: (normals at: sourceIndex) y: (normals at: sourceIndex + 1) z: (normals at: sourceIndex + 2).
		
		"Compute the predominant normal plane."
		normalAxis := self computeNormalAxis: normal.
		tangent := self tangentForAxis: normalAxis.
		bitangent := self bitangentForAxis: normalAxis.
		
		"Compute the new texcoord"
		uv := Vector2 x: (tangent dot: position) y: (bitangent dot: position).
		transformedUV := transformMatrix transformVector2: uv.

		texcoords0
			add: transformedUV x; add: transformedUV y.		

		sourceIndex := sourceIndex + 3.
	].

]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithFacePlanarTransformWithScale: scale [
	^ self generateTexcoords0WithFacePlanarTransform: (Matrix3x3 texScale: scale offset: 0)
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithFacePlanarTransformWithScale: scale offset: offset [
	^ self generateTexcoords0WithFacePlanarTransform: (Matrix3x3 texScale: scale offset: offset)
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjection [
	^ self generateTexcoords0WithSphericalProjectionWithCenter: Vector3 zeros
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjectionWithCenter: center [
	self generateTexcoords0WithSphericalProjectionWithCenter: center radiuses: Vector3 ones
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjectionWithCenter: center radiuses: radiuses [
	self generateTexcoords0WithSphericalProjectionWithCenter: center radiuses: radiuses scale: Vector2 ones
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjectionWithCenter: center radiuses: radiuses scale: scale [
	| sourceIndex |
	self assert: self hasValidPositions.
	texcoords0 := OrderedCollection new: vertexCount * 2.
	sourceIndex := 1.
	1 to: vertexCount do: [ :i |
		| x y l z u v |
		"Fetch the position and normal"
		x := ((positions at: sourceIndex) - center x) / radiuses x.
		y := ((positions at: sourceIndex + 1) - center y) / radiuses y.
		z := ((positions at: sourceIndex + 2) - center z) / radiuses z.
		l := ((x*x) + (y*y) + (z*z)) sqrt.
		l > 0.0 ifTrue: [ 
			x := x/l.
			y := y/l.
			z := z/l.
		].
		
		"Compute the new texcoord"
		u := z arcTan: x.
		v := y arcSin.

		texcoords0 add: (u / Float pi * 0.5 + 0.5) * scale x; add: (v / Float halfPi * -0.5 + 0.5) * scale y.

		sourceIndex := sourceIndex + 3.
	].

]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjectionWithCenter: center scale: scale [
	self generateTexcoords0WithSphericalProjectionWithCenter: center radiuses: Vector3 ones scale: scale
]

{ #category : #'texture coordinate generation' }
WDMeshBuilder >> generateTexcoords0WithSphericalProjectionWithScale: scale [
	^ self generateTexcoords0WithSphericalProjectionWithCenter: Vector3 zeros scale: scale
]

{ #category : #testing }
WDMeshBuilder >> hasValidNormals [
	^ normals size = (vertexCount * 3)
]

{ #category : #testing }
WDMeshBuilder >> hasValidPositions [
	^ positions size = (vertexCount * 3)
]

{ #category : #testing }
WDMeshBuilder >> hasValidTexcoords0 [
	^ texcoords0 size = (vertexCount * 2)
]

{ #category : #testing }
WDMeshBuilder >> hasValidTexcoords1 [
	^ texcoords1 size = (vertexCount * 1)
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

{ #category : #adding }
WDMeshBuilder >> privateAddCubeSphereWithRadius: radius subdivisions: subdivisions quads: quads [
	| subdividedQuads |
	subdivisions <= 0 ifTrue: [
		| positionDictionary sphereVertexCount |
		positionDictionary := Dictionary new.

		self beginTriangles.
		sphereVertexCount := 0.
		
		quads do: [ :eachQuad |
			self addQuadIndices: (eachQuad collect: [ :position |
				positionDictionary at: position ifAbsentPut: [
					| normal |
					sphereVertexCount := sphereVertexCount + 1.
					normal := position normalized.
					self addP: normal * radius; addN: normal.
					sphereVertexCount - 1
				]
			])
		].
	
		^ self
	].

	subdividedQuads := OrderedCollection new.
	quads do: [ :quad |
		| bl br tr tl l r b t m|
		bl := quad first.
		br := quad second.
		tr := quad third.
		tl := quad fourth.

		l := (tl + bl) / 2.
		r := (tr + br) / 2.
		b := (br + bl) / 2.
		t := (tr + tl) / 2.
		m := (bl + br + tr + tl) / 2.
		
		bl := bl normalized.
		br := br normalized.
		tl := tl normalized.
		tr := tr normalized.

		l := l normalized.
		r := r normalized.
		b := b normalized.
		t := t normalized.
		m := m normalized.

		subdividedQuads
			add: { l . bl . b . m };
			add: { b . br . r . m };
			add: { r . tr . t . m };
			add: { t . tl . l . m }.
	].

	self privateAddCubeSphereWithRadius: radius subdivisions: subdivisions - 1 quads: subdividedQuads

]

{ #category : #initialization }
WDMeshBuilder >> reset [
	currentTransform := TRSTransform3D identity.
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

{ #category : #private }
WDMeshBuilder >> tangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 1) rem: NormalAxis size) + 1
]

{ #category : #accessing }
WDMeshBuilder >> tangents4 [
	^ tangents4
]

{ #category : #accessing }
WDMeshBuilder >> texcoords0 [

	^ texcoords0
]

{ #category : #accessing }
WDMeshBuilder >> texcoords1 [
	^ texcoords1
]

{ #category : #transform }
WDMeshBuilder >> translateToX: x y: y z: z [
	currentTransform translateToX: x y: y z: z
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
