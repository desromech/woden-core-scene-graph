"
I am used for building gltf 2 model files.
"
Class {
	#name : 'WDSRWGLTF2Builder',
	#superclass : 'Object',
	#instVars : [
		'nodes',
		'meshes',
		'convertedMeshDictionary',
		'accessors',
		'buffers',
		'bufferViews',
		'convertedAccessorDictionary',
		'convertedBufferViews',
		'convertedBuffers',
		'scenes',
		'convertedMaterialDictionary',
		'materials',
		'textures',
		'images',
		'convertedTextures'
	],
	#classVars : [
		'ComponentTypeMap',
		'TypeMap',
		'VertexLocationToAttributeMap'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'class initialization' }
WDSRWGLTF2Builder class >> initialize [
	VertexLocationToAttributeMap := Dictionary newFrom: ({
		'POSITION' . WDVertexBufferAttribute positionLocation.
		'NORMAL' . WDVertexBufferAttribute normalLocation.
		'TANGENT' . WDVertexBufferAttribute tangent4Location.
		'TEXCOORD_0' . WDVertexBufferAttribute texcoord0Location.
		'TEXCOORD_1' . WDVertexBufferAttribute texcoord1Location.
		'COLOR_0' . WDVertexBufferAttribute colorLocation.
		'JOINTS_0' . WDVertexBufferAttribute boneIndicesLocation.
		'WEIGHTS_0' . WDVertexBufferAttribute boneWeightsLocation.
	} pairsCollect: [:first :second | second -> first]).
	
	TypeMap := Dictionary newFrom: ({
		'SCALAR' . WDBinaryBufferAccessorScalarType asBinaryBufferAccessorType.
		'VEC2' . WDBinaryBufferAccessorVector2Type asBinaryBufferAccessorType.
		'VEC3' . WDBinaryBufferAccessorVector3Type asBinaryBufferAccessorType.
		'VEC4' . WDBinaryBufferAccessorVector4Type asBinaryBufferAccessorType.
		'MAT4' . WDBinaryBufferAccessorMatrix4x4Type asBinaryBufferAccessorType.
	} pairsCollect: [:first :second | second -> first]).
	
	ComponentTypeMap := Dictionary newFrom: ({
		GL_UNSIGNED_BYTE . WDBinaryBufferAccessorUInt8ComponentType asBinaryBufferAccessorComponentType.
		GL_BYTE . WDBinaryBufferAccessorInt8ComponentType asBinaryBufferAccessorComponentType.
		GL_UNSIGNED_SHORT . WDBinaryBufferAccessorUInt16ComponentType asBinaryBufferAccessorComponentType.
		GL_SHORT . WDBinaryBufferAccessorInt16ComponentType asBinaryBufferAccessorComponentType.
		GL_UNSIGNED_INT . WDBinaryBufferAccessorUInt32ComponentType asBinaryBufferAccessorComponentType.
		GL_INT . WDBinaryBufferAccessorInt32ComponentType asBinaryBufferAccessorComponentType.

		GL_FLOAT . WDBinaryBufferAccessorFloat32ComponentType asBinaryBufferAccessorComponentType.
		GL_DOUBLE . WDBinaryBufferAccessorFloat64ComponentType asBinaryBufferAccessorComponentType.
	} pairsCollect: [:first :second | second -> first]).

]

{ #category : 'initialization' }
WDSRWGLTF2Builder >> buildJson [
	| jsonDictionary |
	jsonDictionary := OrderedDictionary new.
	jsonDictionary at: 'asset' put: (OrderedDictionary new
		at: 'version' put: '2.0';
		yourself).
	jsonDictionary at: 'buffers' put: (buffers collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'bufferViews' put: (bufferViews collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'accessors' put: (accessors collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'images' put: (images collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'materials' put: (materials collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'meshes' put: (meshes collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'nodes' put: (nodes collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'scenes' put: (scenes collect: [:each | each encodeForJson] as: Array).
	jsonDictionary at: 'textures' put: (textures collect: [:each | each encodeForJson] as: Array).

	^ STONJSON toStringPretty: jsonDictionary
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> buildMeshDuring: aBlock [
	| mesh |
	mesh := WDSRWGLTF2BuilderMesh new index: meshes size; yourself.
	meshes add: mesh.
	aBlock cull: mesh.
	^ mesh
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> convertAccessor: anAccessor [
	^ convertedAccessorDictionary at: anAccessor ifAbsentPut: [
		| accessor |
		accessor := WDSRWGLTF2BuilderAccessor new.
		accessor index: accessors size.
		accessors add: accessor.
		accessor bufferView: (self convertBufferView: anAccessor bufferView).
		accessor byteOffset: anAccessor byteOffset.
		accessor count: anAccessor count.
		accessor componentType: (ComponentTypeMap at: anAccessor componentType).
		accessor type: (TypeMap at: anAccessor type).
		((anAccessor min ~= (Array new: 16 withAll: 0)) or: [anAccessor max ~= (Array new: 16 withAll: 0)]) ifTrue: [ 
			accessor min: anAccessor min.
			accessor max: anAccessor max.
		].
		accessor
	]
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> convertBuffer: aBuffer [
	self assert: aBuffer isNotNil.
	^ convertedBuffers at: aBuffer ifAbsentPut: [
		| buffer |
		buffer := WDSRWGLTF2BuilderBuffer new.
		buffer index: buffers size.
		buffers add: buffer.
		buffer name: aBuffer name.
		buffer data: aBuffer data.
		
		buffer
	]
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> convertBufferView: aBufferView [
	self assert: aBufferView isNotNil.
	^ convertedBufferViews at: aBufferView ifAbsentPut: [
		| bufferView |
		bufferView := WDSRWGLTF2BuilderBufferView new.
		bufferView index: bufferViews size.
		bufferViews add: bufferView.
		bufferView buffer: (self convertBuffer: aBufferView buffer).
		bufferView byteOffset: aBufferView byteOffset.
		bufferView byteLength: aBufferView byteLength.
		bufferView byteStride: aBufferView byteStride.
		
		bufferView
	]
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> convertMaterial: aMaterial [
	^ convertedMaterialDictionary at: aMaterial ifAbsentPut: [
		| material |
		material := aMaterial asGltf2MaterialWithBuilder: self.
		material index: materials size.
		materials add: material.
		material
	]
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> convertTexture: aTexture [
	aTexture ifNil: [ ^ nil ].
	^ convertedTextures at: aTexture ifAbsentPut: [
		| textureImageData image texture |
		textureImageData := ByteArray streamContents: [ :out | PNGReadWriter putForm: aTexture data onStream: out].
		image := WDSRWGLTF2BuilderImage new
			index: images size;
			data: textureImageData;
			yourself.
		images add: image.
		
		texture := WDSRWGLTF2BuilderTexture new
			index: textures size;
			source: image;
			yourself.
		textures add: texture.
		texture
	]
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> forMesh: aMesh exportWith: aBlock [
	^ convertedMeshDictionary at: aMesh ifAbsentPut: [ 
		| mesh |
		mesh := WDSRWGLTF2BuilderMesh new.
		mesh index: meshes size.
		meshes add: mesh.
		aBlock value: mesh.
		mesh
	]
]

{ #category : 'initialization' }
WDSRWGLTF2Builder >> initialize [
	super initialize.
	accessors := OrderedCollection new.
	buffers := OrderedCollection new.
	bufferViews := OrderedCollection new.
	images := OrderedCollection new.
	materials := OrderedCollection new.
	meshes := OrderedCollection new.
	nodes := OrderedCollection new.
	scenes := OrderedCollection new.
	textures := OrderedCollection new.
	
	convertedMaterialDictionary := Dictionary new.
	convertedMeshDictionary := Dictionary new.
	convertedAccessorDictionary := Dictionary new.
	convertedBufferViews := Dictionary new.
	convertedBuffers := Dictionary new.
	convertedTextures := Dictionary new.
	
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> mapVertexLocationToAttribute: location [
	^ VertexLocationToAttributeMap at: location

]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> newNode: name [
	| node |
	node := WDSRWGLTF2BuilderNode new name: name; index: nodes size yourself.
	nodes add: node.
	^ node
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> newPrimitive [
	^ WDSRWGLTF2BuilderPrimitive new
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2Builder >> newScene: name [
	| scene |
	scene := WDSRWGLTF2BuilderScene new name: name; index: scenes size yourself.
	scenes add: scene.
	^ scene
]
