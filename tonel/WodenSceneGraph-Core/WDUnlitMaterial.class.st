"
I am a material that has a flat coloring (i.e. no lighting).

My parameters are taken from the gltf 2.0 spec for model formats.
"
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

{ #category : #'double dispatch' }
WDUnlitMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitUnlitMaterialActivationCommands: self
]

{ #category : #initialization }
WDUnlitMaterial >> initialize [
	super initialize.
	
	colorFactor := Vector4 ones.
]
