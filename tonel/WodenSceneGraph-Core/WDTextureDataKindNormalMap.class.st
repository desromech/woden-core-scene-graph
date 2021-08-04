"
I represent normal texture data. My XYZ data must be normalized to a length of 1.
"
Class {
	#name : #WDTextureDataKindNormalMap,
	#superclass : #WDTextureDataKind,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureDataKindNormalMap >> isNormalMapData [
	^ true
]
