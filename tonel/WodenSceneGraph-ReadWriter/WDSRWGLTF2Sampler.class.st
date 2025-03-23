"
I specify a texture sampler in a glTF 2 model.
"
Class {
	#name : 'WDSRWGLTF2Sampler',
	#superclass : 'Object',
	#instVars : [
		'minFilter',
		'magFilter',
		'wrapS',
		'wrapT'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> magFilter [
	^ magFilter
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> magFilter: anObject [
	magFilter := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> minFilter [
	^ minFilter
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> minFilter: anObject [
	minFilter := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> wrapS [
	^ wrapS
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> wrapS: anObject [
	wrapS := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> wrapT [
	^ wrapT
]

{ #category : 'accessing' }
WDSRWGLTF2Sampler >> wrapT: anObject [
	wrapT := anObject
]
