"
I am a specific image in a glTF 2 model.
"
Class {
	#name : #WDSRWGLTF2Image,
	#superclass : #Object,
	#instVars : [
		'imageData',
		'form',
		'name'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #converting }
WDSRWGLTF2Image >> asColorTexture [
	^ WDTexture forColorForm: self form
]

{ #category : #converting }
WDSRWGLTF2Image >> asNonColorTexture [
	^ WDTexture forNonColorForm: self form
]

{ #category : #converting }
WDSRWGLTF2Image >> asNormalTexture [
	^ WDTexture forNormalMapForm: self form
]

{ #category : #converting }
WDSRWGLTF2Image >> extent [
	^ self form extent
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Image >> form [
	^ form ifNil: [form := ImageReadWriter formFromStream: imageData readStream ].
]

{ #category : #accessing }
WDSRWGLTF2Image >> imageData [
	^ imageData
]

{ #category : #accessing }
WDSRWGLTF2Image >> imageData: anObject [
	imageData := anObject
]

{ #category : #initialization }
WDSRWGLTF2Image >> initialize [
	super initialize.
	name := ''.
]

{ #category : #accessing }
WDSRWGLTF2Image >> name [
	^ name
]

{ #category : #accessing }
WDSRWGLTF2Image >> name: anObject [
	name := anObject
]
