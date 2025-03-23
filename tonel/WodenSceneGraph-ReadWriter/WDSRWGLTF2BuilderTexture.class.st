Class {
	#name : 'WDSRWGLTF2BuilderTexture',
	#superclass : 'Object',
	#instVars : [
		'index',
		'source'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'initialization' }
WDSRWGLTF2BuilderTexture >> encodeForJson [
	| bufferDict |
	bufferDict := OrderedDictionary new.
	bufferDict at: 'source' put: source index.
	
	^ bufferDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderTexture >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderTexture >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderTexture >> source [

	^ source
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderTexture >> source: anObject [

	source := anObject
]
