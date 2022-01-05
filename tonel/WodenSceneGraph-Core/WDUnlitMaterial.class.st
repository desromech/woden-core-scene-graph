"
I am a material that has a flat coloring (i.e. no lighting).

My parameters are taken from the gltf 2.0 spec for model formats.
"
Class {
	#name : #WDUnlitMaterial,
	#superclass : #WDSurfaceMaterial,
	#instVars : [
		'colorFactor',
		'colorTexture',
		'texcoordScale',
		'texcoordOffset',
		'texcoordOffsetVelocity'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDUnlitMaterial >> colorFactor [

	^ colorFactor
]

{ #category : #accessing }
WDUnlitMaterial >> colorFactor: aColor [

	colorFactor := aColor asVector4 
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
	
	texcoordScale := Vector2 ones.
	texcoordOffset := Vector2 zeros.
	texcoordOffsetVelocity := Vector2 zeros.
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordOffset [

	^ texcoordOffset
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordOffset: anObject [

	texcoordOffset := anObject
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordOffsetVelocity [

	^ texcoordOffsetVelocity
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordOffsetVelocity: anObject [

	texcoordOffsetVelocity := anObject
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordScale [

	^ texcoordScale
]

{ #category : #accessing }
WDUnlitMaterial >> texcoordScale: anObject [

	texcoordScale := anObject
]
