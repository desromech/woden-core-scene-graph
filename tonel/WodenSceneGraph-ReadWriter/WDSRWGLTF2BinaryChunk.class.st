"
I represent a single chunk in a GLTF 2 binary file.
"
Class {
	#name : #WDSRWGLTF2BinaryChunk,
	#superclass : #Object,
	#instVars : [
		'type',
		'content'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDSRWGLTF2BinaryChunk >> content [
	^ content
]

{ #category : #accessing }
WDSRWGLTF2BinaryChunk >> content: anObject [
	content := anObject
]

{ #category : #testing }
WDSRWGLTF2BinaryChunk >> isBinary [
	^ type = "'BIN ' asByteArray" #[66 73 78 0]
]

{ #category : #testing }
WDSRWGLTF2BinaryChunk >> isJSON [
	^ type = "'JSON' asByteArray" #[74 83 79 78]
]

{ #category : #accessing }
WDSRWGLTF2BinaryChunk >> type [
	^ type
]

{ #category : #accessing }
WDSRWGLTF2BinaryChunk >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2BinaryChunk >> utf8ReadStream [
	^ Smalltalk at: #ZnCharacterReadStream
		ifPresent: [ :cls | cls on: content readStream encoding: 'utf8' ]
		ifAbsent: [
			"HACK: for Squeak"
			content asString readStream
		]
]
