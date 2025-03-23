Class {
	#name : 'WDSRWGLTF2BuilderImage',
	#superclass : 'Object',
	#instVars : [
		'index',
		'data'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderImage >> data [

	^ data
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderImage >> data: anObject [

	data := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderImage >> encodeForJson [
	| bufferDict |
	bufferDict := OrderedDictionary new.
	bufferDict at: 'uri' put: 'data:application/octet-stream;base64,', data base64Encoded.
	
	^ bufferDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderImage >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderImage >> index: anObject [

	index := anObject
]
