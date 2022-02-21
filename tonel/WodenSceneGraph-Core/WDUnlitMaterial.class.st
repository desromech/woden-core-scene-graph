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
WDUnlitMaterial class >> typeName [
	^ #Unlit
]

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

{ #category : #serialization }
WDUnlitMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#colorFactor . colorFactor encodeForJSON.
		#colorTexture . colorTexture ifNotNil: [:texture | texture encodeForJSON].
		#texcoordScale . texcoordScale encodeForJSON.
		#texcoordOffset . texcoordOffset encodeForJSON.
		#texcoordOffsetVelocity . texcoordOffsetVelocity encodeForJSON.
	}
]

{ #category : #initialization }
WDUnlitMaterial >> initialize [
	super initialize.
	
	colorFactor := Vector4 ones.
	
	texcoordScale := Vector2 ones.
	texcoordOffset := Vector2 zeros.
	texcoordOffsetVelocity := Vector2 zeros.
]

{ #category : #serialization }
WDUnlitMaterial >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	jsonData at: #colorFactor ifPresent: [ :found | colorFactor := Vector4 loadFromJson: found ].
	jsonData at: #colorTexture ifPresent: [ :found | colorTexture := WDTexture loadFromJson: found inDirectory: materialDirectory ].

	jsonData at: #texcoordScale ifPresent: [ :found | texcoordScale := Vector2 loadFromJson: found ].
	jsonData at: #texcoordOffset ifPresent: [ :found | texcoordOffset := Vector2 loadFromJson: found ].
	jsonData at: #texcoordOffsetVelocity ifPresent: [ :found | texcoordOffsetVelocity := Vector2 loadFromJson: found ].
]

{ #category : #'as yet unclassified' }
WDUnlitMaterial >> makeThumbnail [
	colorTexture ifNotNil: [ colorTexture makeThumbnail ifNotNil: [ :thumb | ^ thumb ] ].
	^ (Form extent: 16@16 depth: 32)
		fillColor: colorFactor asColor;
		yourself
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
