Class {
	#name : #WDSRWGGLTF2Texture,
	#superclass : #Object,
	#instVars : [
		'image',
		'sampler',
		'normalTexture',
		'nonColorTexture',
		'colorTexture'
	],
	#pools : [
		'WDSRWGGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #adding }
WDSRWGGLTF2Texture >> addOntoModelAsset: modelAsset [
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

{ #category : #converting }
WDSRWGGLTF2Texture >> asColorTexture [
	^ colorTexture ifNil: [ colorTexture := image asColorTexture ]
]

{ #category : #converting }
WDSRWGGLTF2Texture >> asNonColorTexture [
	^ nonColorTexture ifNil: [ nonColorTexture := image asNonColorTexture ]
]

{ #category : #converting }
WDSRWGGLTF2Texture >> asNormalTexture [
	^ normalTexture ifNil: [ normalTexture := image asNormalTexture ]
]

{ #category : #accessing }
WDSRWGGLTF2Texture >> image [
	^ image
]

{ #category : #accessing }
WDSRWGGLTF2Texture >> image: anObject [
	image := anObject
]

{ #category : #accessing }
WDSRWGGLTF2Texture >> sampler [
	^ sampler
]

{ #category : #accessing }
WDSRWGGLTF2Texture >> sampler: anObject [
	sampler := anObject
]
