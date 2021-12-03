"
I am HDRI environment map image using an equirectangular projection, and typically encoded in a compressed form.
"
Class {
	#name : #WDTextureDataKindHDRI,
	#superclass : #WDTextureDataKind,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureDataKindHDRI >> isHDRIData [
	^ true
]
