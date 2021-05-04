Class {
	#name : #WDUnlitMaterial,
	#superclass : #WDSurfaceMaterial,
	#instVars : [
		'colorFactor',
		'colorTexture'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDUnlitMaterial >> colorFactor [

	^ colorFactor
]

{ #category : #accessing }
WDUnlitMaterial >> colorFactor: anObject [

	colorFactor := anObject
]

{ #category : #accessing }
WDUnlitMaterial >> colorTexture [

	^ colorTexture
]

{ #category : #accessing }
WDUnlitMaterial >> colorTexture: anObject [

	colorTexture := anObject
]
