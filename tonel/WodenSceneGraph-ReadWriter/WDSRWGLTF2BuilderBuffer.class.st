Class {
	#name : 'WDSRWGLTF2BuilderBuffer',
	#superclass : 'Object',
	#instVars : [
		'name',
		'index',
		'data',
		'byteLength'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> data [

	^ data
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> data: anObject [

	data := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderBuffer >> encodeForJson [
	| bufferDict |
	bufferDict := OrderedDictionary new.
	name ifNotNil: [ 
		bufferDict at: 'name' put: name
	].
	bufferDict at: 'byteLength' put: data size.
	bufferDict at: 'uri' put: 'data:application/octet-stream;base64,', data base64Encoded.
	
	^ bufferDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderBuffer >> name: anObject [

	name := anObject
]
