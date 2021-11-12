Class {
	#name : #WDSRWGLTF2Importer,
	#superclass : #Object,
	#instVars : [
		'loadingDirectory',
		'buffers',
		'bufferViews',
		'accessors',
		'materials',
		'meshes',
		'nodes',
		'scenes',
		'currentGLTFJson',
		'images',
		'samplers',
		'textures',
		'defaultMaterial',
		'skins',
		'nodeBoneStates',
		'nodeToBoneIndices',
		'animations',
		'nodeToArmature',
		'nodesUsingSkin',
		'convertedVertexBindings',
		'convertedVertexAttributes'
	],
	#classVars : [
		'ComponentTypeMap',
		'PrimitiveModeMap',
		'TypeMap',
		'VertexAttributeToLocationMap'
	],
	#pools : [
		'AGPUConstants',
		'WDSRWGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #'class initialization' }
WDSRWGLTF2Importer class >> initialize [
	WDSRWGLTF2Constants initialize.
	TypeMap := Dictionary newFromPairs: {
		'SCALAR' . WDBinaryBufferAccessorScalarType asBinaryBufferAccessorType.
		'VEC2' . WDBinaryBufferAccessorVector2Type asBinaryBufferAccessorType.
		'VEC3' . WDBinaryBufferAccessorVector3Type asBinaryBufferAccessorType.
		'VEC4' . WDBinaryBufferAccessorVector4Type asBinaryBufferAccessorType.
		'MAT4' . WDBinaryBufferAccessorMatrix4x4Type asBinaryBufferAccessorType.
	}.
	
	VertexAttributeToLocationMap := Dictionary newFromPairs: {
		'POSITION' . WDVertexBufferAttribute positionLocation.
		'NORMAL' . WDVertexBufferAttribute normalLocation.
		'TANGENT' . WDVertexBufferAttribute tangent4Location.
		'TEXCOORD_0' . WDVertexBufferAttribute texcoord0Location.
		'TEXCOORD_1' . WDVertexBufferAttribute texcoord1Location.
		'COLOR_0' . WDVertexBufferAttribute colorLocation.
		'JOINTS_0' . WDVertexBufferAttribute boneIndicesLocation.
		'WEIGHTS_0' . WDVertexBufferAttribute boneWeightsLocation.
	}.

	PrimitiveModeMap := Dictionary newFromPairs: {
		GL_POINTS . WDPrimitiveTopologyPoints asPrimitiveTopology.
		GL_LINES . WDPrimitiveTopologyLines asPrimitiveTopology.
		GL_LINE_STRIP . WDPrimitiveTopologyLineStrip asPrimitiveTopology.
		GL_TRIANGLES . WDPrimitiveTopologyTriangles asPrimitiveTopology.
		GL_TRIANGLE_STRIP . WDPrimitiveTopologyTriangleStrip asPrimitiveTopology.
	}.

	ComponentTypeMap := Dictionary newFromPairs: {
		GL_UNSIGNED_BYTE . WDBinaryBufferAccessorUInt8ComponentType asBinaryBufferAccessorComponentType.
		GL_BYTE . WDBinaryBufferAccessorInt8ComponentType asBinaryBufferAccessorComponentType.
		GL_UNSIGNED_SHORT . WDBinaryBufferAccessorUInt16ComponentType asBinaryBufferAccessorComponentType.
		GL_SHORT . WDBinaryBufferAccessorInt16ComponentType asBinaryBufferAccessorComponentType.
		GL_UNSIGNED_INT . WDBinaryBufferAccessorUInt32ComponentType asBinaryBufferAccessorComponentType.
		GL_INT . WDBinaryBufferAccessorInt32ComponentType asBinaryBufferAccessorComponentType.

		GL_FLOAT . WDBinaryBufferAccessorFloat32ComponentType asBinaryBufferAccessorComponentType.
		GL_DOUBLE . WDBinaryBufferAccessorFloat64ComponentType asBinaryBufferAccessorComponentType.
	}.
	
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> extractBoneGraph: nodeToBoneGraphDictionary topologyFrom: startingNode parent: parentNode visited: visitedNodes nodeToBoneDictionary: nodeToBoneDictionary boneToNodeDictionary: boneToNodeDictionary [
	| newParentNode boneGraphNode |
	newParentNode := parentNode.
	nodeToBoneGraphDictionary at: startingNode ifAbsentPut: [ 
		| extraNonJointBone |
		extraNonJointBone := WDSkeletonBone new
			name: startingNode name;
			transform: (nodeBoneStates at: (nodes indexOf: startingNode));
			yourself.
		nodeToBoneDictionary at: startingNode put: extraNonJointBone.
		boneToNodeDictionary at: extraNonJointBone put: startingNode.
		WDSRWGLTF2SkeletonGraphNode new
			bone: extraNonJointBone;
			yourself
	].
	
	boneGraphNode := nodeToBoneGraphDictionary at: startingNode.
	parentNode ifNotNil: [
		self assert: (boneGraphNode parent isNil or: [boneGraphNode parent == parentNode]).
		boneGraphNode parent: parentNode
	].
	newParentNode := boneGraphNode.

	(visitedNodes includes: startingNode) ifTrue: [ ^ self ].
	visitedNodes add: startingNode.

	startingNode childrenDo: [ :child |
		self extractBoneGraph: nodeToBoneGraphDictionary topologyFrom: child parent: newParentNode visited: visitedNodes nodeToBoneDictionary: nodeToBoneDictionary boneToNodeDictionary: boneToNodeDictionary
	].

]

{ #category : #loading }
WDSRWGLTF2Importer >> getBinaryDataChunkWithIndex: binaryChunkIndex [
	self error: 'Missing required binary data specification.'
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadAccessorFrom: accessorDescription [
	| bufferView componentType type count pixelFormatName byteOffset minValues maxValues max min |
	bufferView := bufferViews at: (accessorDescription at: 'bufferView') + 1.
	componentType := accessorDescription at: 'componentType'.
	type := accessorDescription at: 'type'.
	count := accessorDescription at: 'count'.
	byteOffset := accessorDescription at: 'byteOffset' ifAbsent: [0].
	minValues := accessorDescription at: 'min' ifAbsent: [nil].
	maxValues := accessorDescription at: 'max' ifAbsent: [nil].

	min := max := nil.	
	(minValues isNotNil and: [ maxValues isNotNil ]) ifTrue: [ 
		type = 'SCALAR' ifTrue: [
			min := minValues first.
			max := maxValues first.
		].

		type = 'VEC2' ifTrue: [
			min := Vector2 x: minValues first y: minValues second.
			max := Vector2 x: maxValues first y: maxValues second.
		].

		type = 'VEC3' ifTrue: [
			min := Vector3 x: minValues first y: minValues second z: minValues third.
			max := Vector3 x: maxValues first y: maxValues second z: maxValues third.
		].

		type = 'VEC4' ifTrue: [
			min := Vector4 x: minValues first y: minValues second z: minValues third w: minValues fourth.
			max := Vector4 x: maxValues first y: maxValues second z: maxValues third w: maxValues fourth.
		].

	].

	accessors add: (WDBinaryBufferAccessor new
		name: (accessorDescription at: 'name' ifAbsent: [ '' ]);
		bufferView: bufferView;
		byteOffset: byteOffset;
		type: (TypeMap at: type);
		componentType: (ComponentTypeMap at: componentType);
		count: count;
		min: min;
		max: max;
		yourself)
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadAccessorsFrom: elements [
	accessors := OrderedCollection new.
	elements do: [ :el | self loadAccessorFrom: el ]
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> loadAnimationChannelFrom: channelDescription withSamplers: animationSamplers [
	| channel targetDescription |
	channel := WDSRWGLTF2AnimationChannel new.
	channel sampler: (animationSamplers at: (channelDescription at: 'sampler') + 1).
	targetDescription := channelDescription at: 'target'.
	channel
		targetArmature: (nodeToArmature at: (targetDescription at: 'node') + 1);
		targetBoneIndex: (nodeToBoneIndices at: (targetDescription at: 'node') + 1);
		targetProperty: (targetDescription at: 'path') asSymbol.
	^ channel
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> loadAnimationFrom: animationDescription [
	| animationSamplers animationChannels |
	animationSamplers := OrderedCollection new.
	animationDescription at: 'samplers' ifPresent: [ :elements |
		elements do: [ :each |
			animationSamplers add: (self loadAnimationSampler: each)
		]
	].

	animationChannels := OrderedCollection new.
	animationDescription at: 'channels' ifPresent: [ :elements |
		elements do: [ :each |
			animationChannels add: (self loadAnimationChannelFrom: each withSamplers: animationSamplers)
		]
	].

	animations add: (WDSRWGLTF2Animation new
		name: (animationDescription at: 'name' ifAbsent: [ nil ]);
		samplers: animationSamplers asArray;
		channels: animationChannels asArray;
		yourself
	)
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> loadAnimationSampler: samplerDescription [
	^ WDSRWGLTF2AnimationSampler new
		inputAccessor: (accessors at: (samplerDescription at: 'input') + 1);
		outputAccessor: (accessors at: (samplerDescription at: 'output') + 1);
		interpolationAlgorithm: (samplerDescription at: 'interpolation' ifAbsent: ['LINEAR']) asSymbol;
		yourself
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> loadAnimationsFrom: elements [
	animations := OrderedCollection new.
	elements do: [ :each |
		self loadAnimationFrom: each
	].

]

{ #category : #loading }
WDSRWGLTF2Importer >> loadBinaryDataFromURI: uri [
	| absolutePath |
	(uri beginsWith: 'data:') ifTrue: [ ^ self parseDataURI: uri ].
	absolutePath := loadingDirectory resolve: uri asFileReference.
	^ absolutePath binaryReadStreamDo: [ :in | in contents ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadBuffer: bufferIndex from: bufferDescription [
	| byteLength description data |
	data := bufferDescription at: 'uri'
		ifPresent: [ :uri | self loadBinaryDataFromURI: uri ]
		ifAbsent: [ self getBinaryDataChunkWithIndex: bufferIndex ].
	byteLength := bufferDescription at: 'byteLength'.
	self assert: data size >= byteLength.
	buffers add: (WDBinaryBuffer new
		name: (bufferDescription at: 'name' ifAbsent: ['']);
		data: data;
		yourself)
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadBufferViewFrom: viewDescription [
	bufferViews add: (WDBinaryBufferView new
		name: (viewDescription at: 'name' ifAbsent: ['']);
		buffer: (buffers at: (viewDescription at: 'buffer') + 1);
		byteOffset: (viewDescription at: 'byteOffset' ifAbsent: [0]);
		byteLength: (viewDescription at: 'byteLength');
		byteStride: (viewDescription at: 'byteStride' ifAbsent: [0]);
		yourself)
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadBufferViewsFrom: elements [
	bufferViews := OrderedCollection new.
	elements do: [ :el | self loadBufferViewFrom: el ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadBuffersFrom: elements [
	buffers := OrderedCollection new.
	elements doWithIndex: [ :el :index | self loadBuffer: index from: el ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadImageFrom: imageDescription [
	| imageData imageReader imageName image |
	imageData := nil.
	imageReader := nil.
	imageName := imageDescription at: 'name' ifAbsent: [  ].

	imageDescription at: 'uri' ifPresent: [ :uri |
		imageData := self loadBinaryDataFromURI: uri.
	].

	imageDescription at: 'bufferView' ifPresent: [ :bufferViewIndex |
		imageData := bufferViews at: bufferViewIndex + 1.
	].

	image := WDSRWGLTF2Image new
		name: imageName;
		imageData: imageData;
		yourself.
	images add: image
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadImagesFrom: elements [
	images := OrderedCollection new.
	elements do: [ :element | self loadImageFrom: element ].
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMaterialFrom: materialDescription [
	| material |
	material := nil.
	material ifNil: [ 
		materialDescription at: 'pbrMetallicRoughness' ifPresent: [ :description |
			material := self loadMetallicRoughnessMaterial: description commonDescription: materialDescription
		].
	].

	material ifNil: [ material := WDMetallicRoughnessMaterial new ].
	materials add: material
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMaterialsFrom: elements [
	materials := OrderedCollection new.
	elements do: [ :el | self loadMaterialFrom: el ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMeshFrom: meshDescription [
	| name mesh |
	name := meshDescription at: 'name' ifAbsent: [nil].
	mesh := WDStaticMeshRenderable new
		name: name;
		primitives: ((meshDescription at: 'primitives' ifAbsent: [ #() ])
			collect: [ :each | self loadMeshPrimitive: each ]) asArray;
		computeBoundingBoxFromPrimitives;
		yourself.

	meshes add: mesh
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMeshPrimitive: primitiveDescription [
	| primitive attributes vertexAttributes |
	primitive := WDMeshPrimitive new
		boundingBox: AABox empty;
		topology: WDPrimitiveTopologyTriangles;
		yourself.
	
	attributes := primitiveDescription at: 'attributes'.
	primitiveDescription at: 'indices' ifPresent: [ :indicesAccessorIndex |
		primitive indices: (accessors at: indicesAccessorIndex + 1).
	].
	primitiveDescription at: 'material' ifPresent: [ :materialIndex |
		primitive material: (materials at: materialIndex + 1)
	].
	primitiveDescription at: 'mode' ifPresent: [ :mode |
		primitive topology: (PrimitiveModeMap at: mode)
	].
	

	vertexAttributes := OrderedCollection new.
	attributes keysAndValuesDo: [ :attributeName :attributeBinding |
		| location vertexAccessor|
		location := VertexAttributeToLocationMap at: attributeName.
		vertexAccessor := accessors at: attributeBinding + 1.
		convertedVertexAttributes ifNil: [ convertedVertexAttributes := Dictionary new ].
		vertexAttributes add: (convertedVertexAttributes at: {location . vertexAccessor} ifAbsentPut: [
			WDVertexBufferAttribute new
				location: location;
				accessor: vertexAccessor;
				yourself])
	].

	vertexAttributes := vertexAttributes asArray.
	vertexAttributes sort: [ :a :b | a location <= b location ].
	
	convertedVertexBindings ifNil: [convertedVertexBindings := Dictionary new].
	primitive vertexBinding: (convertedVertexBindings at: vertexAttributes ifAbsentPut: [
		WDVertexBufferBinding new
			attributes: vertexAttributes;
			yourself
	]).

	^ primitive

]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMeshesFrom: elements [
	meshes := OrderedCollection new.
	elements do: [ :el | self loadMeshFrom: el ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadMetallicRoughnessMaterial: description commonDescription: commonDescription [
	| material occlusionTexture metallicRoughnessTexture |
	material := WDMetallicRoughnessMaterial new.
	description at: 'baseColorFactor' ifPresent: [ :baseColor |
		material baseColorFactor: (Vector4 x: baseColor first y: baseColor second z: baseColor third w: baseColor fourth)
	] ifAbsent: [
		material baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 1.0)
	].

	material
		metallicFactor: (description at: 'metallicFactor' ifAbsent: [1.0]);
		roughnessFactor: (description at: 'roughnessFactor' ifAbsent: [1.0]).
		
	description at: 'baseColorTexture' ifPresent: [ :textureDescription |
		material baseColorTexture: (textures at: (textureDescription at: 'index') + 1) asColorTexture
	].

	commonDescription at: 'normalTexture' ifPresent: [ :textureDescription |
		material normalTexture: (textures at: (textureDescription at: 'index') + 1) asNormalTexture
	].
	
	commonDescription at: 'occlusionTexture' ifPresent: [ :textureDescription |
		material occlusionTexture: (textures at: (textureDescription at: 'index') + 1) asNonColorTexture
	].

	description at: 'metallicRoughnessTexture' ifPresent: [ :textureDescription |
		material metallicRoughnessTexture: (textures at: (textureDescription at: 'index') + 1) asNonColorTexture.
	].

	material doubleSided: (commonDescription at: 'doubleSided' ifAbsent: [false]).
	commonDescription at: 'alphaMode' ifPresent: [ :alphaMode |
		material alphaMode: alphaMode.
	].

	material alphaCutoff: (commonDescription at: 'alphaCutoff' ifAbsent: [0.5]).

	commonDescription at: 'emissiveFactor' ifPresent: [ :factor |
		material emissiveFactor: (Vector3 x: factor first y: factor second z: factor third)
	] ifAbsent: [
		material emissiveFactor: Vector3 zeros
	].

	commonDescription at: 'emissiveTexture' ifPresent: [ :textureDescription |
		material emissiveTexture: (textures at: (textureDescription at: 'index') + 1) asColorTexture
	].

	^ material
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadNode: node childrenFrom: nodeDescription [
	nodeDescription at: 'children' ifPresent: [ :children |
		children do: [ :childIndex |
			node add: (nodes at: childIndex + 1)
		]
	]
	
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadNodeFrom: nodeDescription [
	| node cameraDescription perspective transform |
	node := WDSceneNode new.

	nodeDescription at: 'mesh' ifPresent: [ :meshIndex |
		| mesh |
		mesh := meshes at: meshIndex + 1.
		node renderables: {mesh}.
		nodeDescription at: 'skin' ifPresent: [ :skinIndex |
			| skin |
			skin := (skins at: skinIndex + 1).
			nodesUsingSkin at: skin put: node.
			node renderables: {WDSkeletalMeshRenderable new
				referenceMesh: mesh;
				skeleton: skin skeleton;
				yourself}
		]
	].

	nodeDescription at: 'camera' ifPresent: [ :cameraIndex |
		| camera |
		camera := WDCamera new.
		cameraDescription := (currentGLTFJson at: 'cameras') at: cameraIndex + 1.
		perspective := cameraDescription at: 'perspective'.
		node camera: camera.
		camera
			fovY: (perspective at: 'yfov') radiansToDegrees;
			nearDistance: (perspective at: 'znear');
			farDistance: (perspective at: 'zfar').
	].

	transform := TRSTransform3D new.
	nodeDescription at: 'matrix' ifPresent: [ :matrixElements |
		"node transform: (ReversibleAffineTransform3dF32 fromInvertibleMatrix4: (Float32x4x4 columns: matrixElements))."
		self halt.
	].

	nodeDescription at: 'scale' ifPresent: [ :scaleComponent |
		transform scale: (Vector3 x: scaleComponent first y: scaleComponent second z: scaleComponent third).
	].

	nodeDescription at: 'rotation' ifPresent: [ :rotationComponent |
		transform rotation: (Quaternion r: rotationComponent fourth i: rotationComponent first j: rotationComponent second k: rotationComponent third).
	].

	nodeDescription at: 'translation' ifPresent: [ :translationComponent |
		transform translation: (Vector3 x: translationComponent first y: translationComponent second z: translationComponent third)
	].

	node transform: transform.
	node name: (nodeDescription at: 'name' ifAbsent: [ '' ]).
	nodes add: node.
	nodeBoneStates add: transform
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadNodesFrom: elements [
	nodes := OrderedCollection new.
	nodeBoneStates := OrderedCollection new.
	nodesUsingSkin := Dictionary new.
	elements do: [ :el | self loadNodeFrom: el ].
	elements doWithIndex: [ :el :index | self loadNode: (nodes at: index) childrenFrom: el].
	
	nodeToArmature := Array new: nodes size.
	nodeToBoneIndices := (Array new: nodes size) atAllPut: -1.
	skins ifNotNil: [
		skins do: [ :each | self loadSkinTopology: each ]
	]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadSamplerFrom: samplerDescription [
	| sampler |
	sampler := WDSRWGLTF2Sampler new.
	self flag: 'TODO: Parse the sampler description.'.
	samplers add: sampler
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadSamplersFrom: elements [
	samplers := OrderedCollection new.
	elements do: [ :el | self loadSamplerFrom: el ].
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadSceneFrom: sceneDescription [
	| scene |
	scene := WDScene new.
	scene name: (sceneDescription at: 'name' ifAbsent: [ nil ]).
	sceneDescription at: 'nodes' ifPresent: [ :nodeIndices |
		nodeIndices do: [ :nodeIndex |
			scene add: (nodes at: nodeIndex + 1 )
		]
	].
	
	scenes add: scene
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadScenesFrom: elements [
	scenes := OrderedCollection new.
	elements do: [ :el | self loadSceneFrom: el ]
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadSkinFrom: skinDescription [
	| skin |
	skin := WDSRWGLTF2Skin new.
	skin
		name: (skinDescription at: 'name' ifAbsent: [ nil ]);
		jointIndices: (skinDescription at: 'joints'	);
		rootNodeIndex: (skinDescription at: 'skeleton' ifAbsent: [ nil ]).
	skinDescription at: 'inverseBindMatrices' ifPresent: [ :accessorIndex |
		skin inverseBindMatricesAccessor: (accessors at: accessorIndex + 1)
	].
	skins add: skin.

]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> loadSkinTopology: skin [
	| jointNodes bones visitedNodes sortedBones jointStates boneGraphNodes nodeToBoneGraphDictionary nodeToBoneDictionary boneToNodeDictionary rootMatrix |
	jointNodes := skin jointIndices collect: [ :each | nodes at: each + 1 ].
	jointStates := skin jointIndices collect: [ :each | nodeBoneStates at: each + 1 ].
	nodeToBoneDictionary := IdentityDictionary new.
	boneToNodeDictionary := IdentityDictionary new.
	
	bones := jointNodes collectWithIndex: [ :node :index |
		| bone |
		
		bone := WDSkeletonBone new
			name: node name;
			transform: (jointStates at: index);
			yourself.
		nodeToBoneDictionary at: node put: bone.
		boneToNodeDictionary at: bone put: node.
		bone.
	].

	"We need to sort bone in a way such as parent bones always precede their children. This sorting
	is required to facilitate skinning via a single linear iteration. For correctly achieving this sorting, it is required to perform a topological sort in the transpose graph."
	
	nodeToBoneGraphDictionary := IdentityDictionary new.
	boneGraphNodes := jointNodes collect: [ :node |
		| graphNode |
		graphNode := WDSRWGLTF2SkeletonGraphNode new
			bone: (nodeToBoneDictionary at: node);
			yourself.
		nodeToBoneGraphDictionary at: node put: graphNode.
		graphNode
	].

	visitedNodes := IdentitySet new.
	skin rootNodeIndex ifNotNil: [:nodeIndex |
		| rootNode |
		rootNode := nodes at: nodeIndex + 1.
		self extractBoneGraph: nodeToBoneGraphDictionary topologyFrom: rootNode parent: nil visited: visitedNodes nodeToBoneDictionary: nodeToBoneDictionary boneToNodeDictionary: boneToNodeDictionary
	].

	jointNodes do: [ :node |
		self extractBoneGraph: nodeToBoneGraphDictionary topologyFrom: node parent: nil visited: visitedNodes nodeToBoneDictionary: nodeToBoneDictionary boneToNodeDictionary: boneToNodeDictionary
	].

	visitedNodes := IdentitySet new.
	sortedBones := OrderedCollection new.
	boneGraphNodes do: [ :boneGraphNode |
		self topologicalSortBoneGraphNode: boneGraphNode into: sortedBones visited: visitedNodes.
	].
	self assert: sortedBones isNotEmpty.
	skin rootNode: (boneToNodeDictionary at: sortedBones first).

	rootMatrix := skin rootNode parent
		ifNil: [ Matrix4x4 identity ]
		ifNotNil: [ :p | p globalTransform matrix4 ].

	sortedBones doWithIndex: [ :bone :index |
		bone index: index - 1
	].
	
	sortedBones do: [ :bone |
		| node |
		node := boneToNodeDictionary at: bone.
		bone parentIndex: -1.
		(nodeToBoneGraphDictionary at: node) parent ifNotNil: [ :parentBoneGraphNode |
			| parentBone |
			parentBone := parentBoneGraphNode bone.
			self assert: parentBone index isNotNil.
			self assert: parentBone index < bone index.
			bone parentIndex: parentBone index
		]
	].

	skin jointIndices doWithIndex: [ :nodeIndex :boneIndex |
		nodeToArmature at: nodeIndex + 1 put: skin skeleton.
		nodeToBoneIndices at: nodeIndex + 1 put: (bones at: boneIndex) index
	].

	skin
		jointIndexToBoneIndexPermutationTable: (bones collect: [ :each | each index ]) asArray.

	skin skeleton
		rootMatrix: rootMatrix;
		bones: sortedBones asArray;
		restPoseInverseMatrices: skin permutatedInverseBindMatrices;
		jointIndexToBoneIndexPermutationTable: skin jointIndexToBoneIndexPermutationTable;
		computeRestPoseForwardMatrices.
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadSkinsFrom: elements [
	skins := OrderedCollection new.
	elements do: [ :el | self loadSkinFrom: el ].

]

{ #category : #loading }
WDSRWGLTF2Importer >> loadTextureFrom: textureDescription [
	| texture |
	texture := WDSRWGLTF2Texture new.
	textureDescription at: 'sampler' ifPresent: [ :samplerIndex |
		texture sampler: (samplers at: samplerIndex + 1)
	].

	textureDescription at: 'source' ifPresent: [ :sourceIndex |
		texture image: (images at: sourceIndex + 1)
	].

	textures add: texture	
]

{ #category : #loading }
WDSRWGLTF2Importer >> loadTexturesFrom: elements [
	textures := OrderedCollection new.
	elements do: [ :el | self loadTextureFrom: el ]
]

{ #category : #accessing }
WDSRWGLTF2Importer >> loadingDirectory [
	^ loadingDirectory
]

{ #category : #accessing }
WDSRWGLTF2Importer >> loadingDirectory: anObject [
	loadingDirectory := anObject
]

{ #category : #loading }
WDSRWGLTF2Importer >> parseDataURI: uri [
	| dataStartIndex metadata data mediaTypeAndEncoding mediaType encoding |
	dataStartIndex := uri indexOf: $,.
	metadata := uri copyFrom: 'data:' size + 1 to: dataStartIndex - 1.
	data := uri allButFirst: dataStartIndex.
	mediaTypeAndEncoding := metadata splitOn: $;.
	mediaType := mediaTypeAndEncoding first.
	encoding := mediaTypeAndEncoding second.
	encoding = 'base64' ifFalse: [ 
		self error: 'Unsupported encoding for data uri: ' , encoding
	].
	^ data base64Decoded
]

{ #category : #loading }
WDSRWGLTF2Importer >> processGLTFJson: json [
	| asset |
	currentGLTFJson := json.

	json at: 'buffers' ifPresent: [ :elements | self loadBuffersFrom: elements ].
	json at: 'bufferViews' ifPresent: [ :elements | self loadBufferViewsFrom: elements ].
	json at: 'accessors' ifPresent: [ :elements | self loadAccessorsFrom: elements ].
	json at: 'samplers' ifPresent: [ :elements | self loadSamplersFrom: elements ].
	json at: 'images' ifPresent: [ :elements | self loadImagesFrom: elements ].
	json at: 'textures' ifPresent: [ :elements | self loadTexturesFrom: elements ].
	json at: 'materials' ifPresent: [ :elements | self loadMaterialsFrom: elements ].
	json at: 'skins' ifPresent: [ :elements | self loadSkinsFrom: elements ].
	json at: 'meshes' ifPresent: [ :elements | self loadMeshesFrom: elements ].
	json at: 'nodes' ifPresent: [ :elements | self loadNodesFrom: elements ].
	json at: 'animations' ifPresent: [ :elements | self loadAnimationsFrom: elements ].	
	json at: 'scenes' ifPresent: [ :elements | self loadScenesFrom: elements ].
	skins ifNotNil: [ 
		skins do: [ :each | each rootNode removeFromScene ].
	].

	asset := WDModelAsset new.
	textures ifNotNil: [ 
		textures do: [ :each | each addOntoModelAsset: asset ].
	].
	materials ifNotNil: [ 
		materials do: [ :each | asset addMaterial: each ].
	].
	meshes ifNotNil: [ 
		meshes do: [ :each | asset addMesh: each ].
	].
	scenes ifNotNil: [
		scenes do: [ :each | asset addScene: each ].
	].
	
	^ asset
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> topologicalSortBoneGraphNode: boneGraphNode into: sortedBones visited: visitedNodes [
	(visitedNodes includes: boneGraphNode) ifTrue: [ ^ self ].
	visitedNodes add: boneGraphNode.

	boneGraphNode parent ifNotNil: [ :parent |
		self topologicalSortBoneGraphNode: parent into: sortedBones visited: visitedNodes
	].

	sortedBones add: boneGraphNode bone
]
