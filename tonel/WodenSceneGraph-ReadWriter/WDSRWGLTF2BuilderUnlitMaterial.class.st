Class {
	#name : 'WDSRWGLTF2BuilderUnlitMaterial',
	#superclass : 'WDSRWGLTF2BuilderMaterial',
	#instVars : [
		'colorFactor',
		'colorTexture'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderUnlitMaterial >> colorFactor [

	^ colorFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderUnlitMaterial >> colorFactor: anObject [

	colorFactor := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderUnlitMaterial >> colorTexture [

	^ colorTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderUnlitMaterial >> colorTexture: anObject [

	colorTexture := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderUnlitMaterial >> encodeForJson [
	| materialObj |
	materialObj := super encodeForJson.
	colorTexture ifNotNil: [ 
		materialObj at: 'colorTexture' put: colorTexture index		
	].
	^materialObj
]
