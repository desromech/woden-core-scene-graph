"
I represent a single chunk in a GLTF 2 binary file.
"
Class {
	#name : #WDSRWGGLTF2BinaryChunk,
	#superclass : #Object,
	#instVars : [
		'type',
		'content'
	],
	#pools : [
		'WDSRWGGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDSRWGGLTF2BinaryChunk >> content [
	^ content
]

{ #category : #accessing }
WDSRWGGLTF2BinaryChunk >> content: anObject [
	content := anObject
]

{ #category : #testing }
WDSRWGGLTF2BinaryChunk >> isBinary [
	^ type = "'BIN ' asByteArray" #[66 73 78 0]
]

{ #category : #testing }
WDSRWGGLTF2BinaryChunk >> isJSON [
	^ type = "'JSON' asByteArray" #[74 83 79 78]
]

{ #category : #accessing }
WDSRWGGLTF2BinaryChunk >> type [
	^ type
]

{ #category : #accessing }
WDSRWGGLTF2BinaryChunk >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
WDSRWGGLTF2BinaryChunk >> utf8ReadStream [
	^ ZnCharacterReadStream on: content readStream encoding: 'utf8'
]
