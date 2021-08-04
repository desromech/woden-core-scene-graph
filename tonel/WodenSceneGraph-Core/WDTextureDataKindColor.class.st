"
I represent color texture data. My data is typically in the sRGB color space.
"
Class {
	#name : #WDTextureDataKindColor,
	#superclass : #WDTextureDataKind,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureDataKindColor >> isColorData [
	^ true
]
