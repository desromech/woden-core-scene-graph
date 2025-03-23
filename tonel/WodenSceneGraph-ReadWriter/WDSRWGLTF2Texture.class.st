"
I am a specific texture in a glTF 2 model.
"
Class {
	#name : 'WDSRWGLTF2Texture',
	#superclass : 'Object',
	#instVars : [
		'image',
		'sampler',
		'normalTexture',
		'nonColorTexture',
		'colorTexture'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'adding' }
WDSRWGLTF2Texture >> addOntoModelAsset: modelAsset [
	colorTexture ifNotNil: [
		modelAsset addTexture: colorTexture
	].
	nonColorTexture ifNotNil: [
		modelAsset addTexture: nonColorTexture
	].
	normalTexture ifNotNil: [
		modelAsset addTexture: normalTexture
	].
]

{ #category : 'converting' }
WDSRWGLTF2Texture >> asColorTexture [
	^ colorTexture ifNil: [ colorTexture := image asColorTexture ]
]

{ #category : 'converting' }
WDSRWGLTF2Texture >> asNonColorTexture [
	^ nonColorTexture ifNil: [ nonColorTexture := image asNonColorTexture ]
]

{ #category : 'converting' }
WDSRWGLTF2Texture >> asNormalTexture [
	^ normalTexture ifNil: [ normalTexture := image asNormalTexture ]
]

{ #category : 'accessing' }
WDSRWGLTF2Texture >> image [
	^ image
]

{ #category : 'accessing' }
WDSRWGLTF2Texture >> image: anObject [
	image := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2Texture >> sampler [
	^ sampler
]

{ #category : 'accessing' }
WDSRWGLTF2Texture >> sampler: anObject [
	sampler := anObject
]
