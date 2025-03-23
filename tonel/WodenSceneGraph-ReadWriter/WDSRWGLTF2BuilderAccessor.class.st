Class {
	#name : 'WDSRWGLTF2BuilderAccessor',
	#superclass : 'Object',
	#instVars : [
		'index',
		'bufferView',
		'byteOffset',
		'componentType',
		'type',
		'count'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> bufferView [

	^ bufferView
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> bufferView: anObject [

	bufferView := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> byteOffset [

	^ byteOffset
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> byteOffset: anObject [

	byteOffset := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> componentType [

	^ componentType
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> componentType: anObject [

	componentType := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> count [

	^ count
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> count: anObject [

	count := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderAccessor >> encodeForJson [
	| accessorDict |
	accessorDict := OrderedDictionary new.
	accessorDict at: 'bufferView' put: bufferView index.
	accessorDict at: 'byteOffset' put: byteOffset.
	accessorDict at: 'count' put: count.
	accessorDict at: 'componentType' put: componentType.
	accessorDict at: 'type' put: type.
	^ accessorDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> type [

	^ type
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderAccessor >> type: anObject [

	type := anObject
]
