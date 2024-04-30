"
I am importer for glTF 2 models.
"
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
		'animations',
		'nodesUsingSkin',
		'convertedVertexBindings',
		'convertedVertexAttributes',
		'skeletalMeshes',
		'nodeParents',
		'rootNodes',
		'nodeChildren',
		'lcaTreeWalkIndices',
		'lcaTreeWalkDepths',
		'nodeToLcaQueryIndex',
		'nodeGlobalTransforms'
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

{ #category : #adding }
WDSRWGLTF2Importer >> addNodeIndicesFrom: startingNodeIndex to: stopNodeIndex into: nodeIndices set: nodeIndicesSet [
	| nextNodeIndex |
	(nodeIndicesSet includes: startingNodeIndex) ifTrue: [ 
		^ self
	].

	nodeIndices add: startingNodeIndex.
	nodeIndicesSet add: startingNodeIndex.
	startingNodeIndex = stopNodeIndex ifTrue: [ ^ self ].
	
	nextNodeIndex := nodeParents at: startingNodeIndex + 1.
	nextNodeIndex ifNil: [ ^ self ].
	
	self addNodeIndicesFrom: nextNodeIndex to: stopNodeIndex into: nodeIndices set: nodeIndicesSet
]

{ #category : #loading }
WDSRWGLTF2Importer >> computeNodeGlobalTransform: nodeIndex [
	| parentTransform result |
	(nodeGlobalTransforms at: nodeIndex + 1) ifNotNil: [ :cachedResult | ^ cachedResult ].

	parentTransform := ReversibleAffineTransform3D identity.
	(nodeParents at: nodeIndex + 1) ifNotNil: [ :parentIndex |
		parentTransform := self computeNodeGlobalTransform: parentIndex
	].

	result := parentTransform transformTransform: (nodes at: nodeIndex + 1) transform asReversibleAffineTransform.
	nodeGlobalTransforms at: nodeIndex + 1 put: result.
	^ result
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> computeNodesTopologies [
	rootNodes := OrderedCollection new.
	nodeParents doWithIndex: [ :parentIndex :index |
		parentIndex ifNil: [ 
			rootNodes add: index - 1
		]
	].

	nodeToLcaQueryIndex := Array new: nodes size.
	lcaTreeWalkIndices := OrderedCollection new.
	lcaTreeWalkDepths := OrderedCollection new.
	rootNodes do: [ :eachIndex |
		self lcaTreeWalk: eachIndex depth: 0
	].

]

{ #category : #loading }
WDSRWGLTF2Importer >> getBinaryDataChunkWithIndex: binaryChunkIndex [
	self error: 'Missing required binary data specification.'
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> lcaForNodeIndices: nodeIndices [
	| rangeStopIndex rangeStartIndex lcaDepth lcaResult |
	rangeStartIndex := rangeStopIndex := nodeToLcaQueryIndex at: nodeIndices first + 1.
	nodeIndices do: [ :nodeIndex |
		| queryIndex |
		queryIndex := nodeToLcaQueryIndex at: nodeIndex + 1.
		rangeStartIndex := rangeStartIndex min: queryIndex.
		rangeStopIndex := rangeStopIndex max: queryIndex.
	].

	"Linear algorithm for a full list of node indices to test. Since we have few skeletons, this should be enough."
	lcaDepth := Float infinity.
	lcaResult := nil.
	rangeStartIndex to: rangeStopIndex do: [ :queryIndex |
		| queryDepth |
		queryDepth := lcaTreeWalkDepths at: queryIndex + 1.
		queryDepth < lcaDepth ifTrue: [ 
			lcaDepth := queryDepth.
			lcaResult := lcaTreeWalkIndices at: queryIndex + 1
		]
	].

	^ lcaResult
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> lcaTreeWalk: nodeIndex depth: nodeDepth [
	nodeToLcaQueryIndex at: nodeIndex + 1 put: lcaTreeWalkIndices size.
	lcaTreeWalkIndices add: nodeIndex.
	lcaTreeWalkDepths add: nodeDepth.
	
	(nodeChildren at: nodeIndex + 1) doWithIndex: [ :childIndex :i |
		self lcaTreeWalk: childIndex depth: nodeDepth + 1.

		lcaTreeWalkIndices add: nodeIndex.
		lcaTreeWalkDepths add: nodeDepth.
	].

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
	(minValues notNil and: [ maxValues notNil ]) ifTrue: [ 
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
		targetName: (self validNodeNameForIndex:  (targetDescription at: 'node'));
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

	primitive computeBoundingBoxFromVertexBindingData.
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
WDSRWGLTF2Importer >> loadNode: node index: index childrenFrom: nodeDescription [
	| childrenList |
	childrenList := (nodeDescription at: 'children' ifAbsent: [#()]).
	nodeChildren at: index + 1 put: childrenList.
	
	childrenList do: [ :childIndex |
		self assert: childIndex ~= index.

		node add: (nodes at: childIndex + 1).
		nodeParents at: childIndex + 1 put: index.
	].
	
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
			| skin skeletalMesh|
			skin := (skins at: skinIndex + 1).
			nodesUsingSkin at: skin put: node.
			
			skeletalMesh := WDSkeletalMeshRenderable new
				referenceMesh: mesh;
				skeleton: skin skeleton;
				yourself.
			
			skeletalMeshes ifNil: [ skeletalMeshes := OrderedCollection new ].
			skeletalMeshes add: skeletalMesh.
			node renderables: {skeletalMesh}
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
	nodeParents := Array new: nodes size.
	nodeChildren := Array new: nodes size.
	elements doWithIndex: [ :el :index | self loadNode: (nodes at: index) index: index - 1 childrenFrom: el].
	nodeGlobalTransforms := Array new: nodes size.
	self computeNodesTopologies.
	0 to: nodes size - 1 do: [ :nodeIndex | self computeNodeGlobalTransform: nodeIndex ].
	
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
	| declaredJointIndices lcaRootNodeIndex lcaRootNode nodeToBoneIndexTable bones allJointIndices allJointIndicesSet |
	
	declaredJointIndices := skin jointIndices.
	skin rootNodeIndex ifNotNil: [ :rootNodeIndex |
		(declaredJointIndices includes: rootNodeIndex) ifFalse: [
			declaredJointIndices := declaredJointIndices , { rootNodeIndex }
		]
	].

	lcaRootNodeIndex := self lcaForNodeIndices: declaredJointIndices.
	lcaRootNode := nodes at: lcaRootNodeIndex + 1.
	
	allJointIndices := OrderedCollection new addAll: declaredJointIndices; yourself.
	allJointIndicesSet := Set new addAll: allJointIndices; yourself.

	1 to: 	allJointIndices size do: [ :i |
		self addNodeIndicesFrom: (allJointIndices at: i) to: lcaRootNodeIndex into: allJointIndices set: allJointIndicesSet.
	].

	nodeToBoneIndexTable := Dictionary new.
	allJointIndices doWithIndex: [ :nodeIndex :boneIndex |
		nodeToBoneIndexTable at: nodeIndex put: boneIndex - 1
	].
	
	bones := allJointIndices collectWithIndex: [ :nodeIndex :index |
		| bone node nodeState parentNodeIndex parentBoneIndex baseGlobalTransform |
		node := nodes at: nodeIndex + 1.
		nodeState := nodeBoneStates at: nodeIndex + 1.
		parentNodeIndex := nodeParents at: nodeIndex + 1.
		parentBoneIndex := nodeToBoneIndexTable at: parentNodeIndex ifAbsent: [-1].
		self assert: parentBoneIndex ~= (index - 1).
		baseGlobalTransform := parentNodeIndex >= 0
			ifTrue: [ nodeGlobalTransforms at: parentNodeIndex + 1 ]
			ifFalse: [ ReversibleAffineTransform3D identity ].
		
		bone := WDSkeletonBone new
			name: node name;
			transform: nodeState;
			baseGlobalTransform: baseGlobalTransform;
			index: index - 1;
			parentIndex: parentBoneIndex;
			yourself.
	].

	skin rootNode: lcaRootNode.
	skin skeleton
		rootMatrix: Matrix4x4 identity;
		rootBoneIndex: (nodeToBoneIndexTable at: lcaRootNodeIndex);
		bones: bones asArray;
		restPoseInverseMatrices: skin inverseBindMatrices;
		computeSkinningOrderTable;
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
	skins ifNotNil: [ 
		skins do: [ :each | asset addSkeleton: each skeleton ]
	].
	skeletalMeshes ifNotNil: [ 
		skeletalMeshes do: [ :each | asset addSkeletalMesh: each ]
	].
	scenes ifNotNil: [
		scenes do: [ :each | asset addScene: each ].
	].
	animations ifNotNil: [
		animations do: [ :each | asset addAnimation: each asModelAnimation ].
	].
	
	^ asset
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Importer >> validNodeNameForIndex: nodeIndex [
	| name |
	name := (nodes at: nodeIndex + 1) name.
	^ name isEmpty ifTrue: ['Node' , nodeIndex asString] ifFalse: [name]
	
]
