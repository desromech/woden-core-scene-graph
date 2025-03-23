Class {
	#name : 'WDSRWGLTF2BuilderBufferView',
	#superclass : 'Object',
	#instVars : [
		'index',
		'buffer',
		'byteOffset',
		'byteLength',
		'byteStride'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> buffer [

	^ buffer
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> buffer: anObject [

	buffer := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteLength [

	^ byteLength
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteLength: anObject [

	byteLength := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteOffset [

	^ byteOffset
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteOffset: anObject [

	byteOffset := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteStride [

	^ byteStride
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> byteStride: anObject [

	byteStride := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderBufferView >> encodeForJson [
	| bufferViewDict |
	bufferViewDict := OrderedDictionary new.
	bufferViewDict at: 'buffer' put: buffer index.
	bufferViewDict at: 'byteOffset' put: byteOffset.
	bufferViewDict at: 'byteLength' put: byteLength.
	byteStride > 0 ifTrue: [ 
		bufferViewDict at: 'byteStride' put: byteStride.
	].
	
	^ bufferViewDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBufferView >> index: anObject [

	index := anObject
]
