Class {
	#name : #WDSRWGGLTF2Sampler,
	#superclass : #Object,
	#instVars : [
		'minFilter',
		'magFilter',
		'wrapS',
		'wrapT'
	],
	#pools : [
		'WDSRWGGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDSRWGGLTF2Sampler >> magFilter [
	^ magFilter
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> magFilter: anObject [
	magFilter := anObject
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> minFilter [
	^ minFilter
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> minFilter: anObject [
	minFilter := anObject
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> wrapS [
	^ wrapS
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> wrapS: anObject [
	wrapS := anObject
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> wrapT [
	^ wrapT
]

{ #category : #accessing }
WDSRWGGLTF2Sampler >> wrapT: anObject [
	wrapT := anObject
]
