"
I represent color texture data. My data is typically in the sRGB color space.
"
Class {
	#name : 'WDTextureDataKindColor',
	#superclass : 'WDTextureDataKind',
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'testing' }
WDTextureDataKindColor >> isColorData [
	^ true
]
