Class {
	#name : #WDSRWGGLTF2Image,
	#superclass : #Object,
	#instVars : [
		'imageData',
		'form',
		'name'
	],
	#pools : [
		'WDSRWGGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #converting }
WDSRWGGLTF2Image >> asColorTexture [
	^ WDTexture forColorForm: self form
]

{ #category : #converting }
WDSRWGGLTF2Image >> asNonColorTexture [
	^ WDTexture forNonColorForm: self form
]

{ #category : #converting }
WDSRWGGLTF2Image >> asNormalTexture [
	^ WDTexture forNormalMapForm: self form
]

{ #category : #converting }
WDSRWGGLTF2Image >> extent [
	^ self form extent
]

{ #category : #'as yet unclassified' }
WDSRWGGLTF2Image >> form [
	^ form ifNil: [form := ImageReadWriter formFromStream: imageData readStream ].
]

{ #category : #accessing }
WDSRWGGLTF2Image >> imageData [
	^ imageData
]

{ #category : #accessing }
WDSRWGGLTF2Image >> imageData: anObject [
	imageData := anObject
]

{ #category : #initialization }
WDSRWGGLTF2Image >> initialize [
	super initialize.
	name := ''.
]

{ #category : #accessing }
WDSRWGGLTF2Image >> name [
	^ name
]

{ #category : #accessing }
WDSRWGGLTF2Image >> name: anObject [
	name := anObject
]
