"
I am a cube map texture. The number of layers of textures with my type must be divisible by 6.
"
Class {
	#name : 'WDTextureTypeCube',
	#superclass : 'WDTextureType',
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'testing' }
WDTextureTypeCube >> isCubeTextureType [
	^ true
]
