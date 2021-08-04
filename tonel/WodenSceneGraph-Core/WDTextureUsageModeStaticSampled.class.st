"
I represent the usage mode of textures that are only uploaded from the CPU, and then they are constantly sampled.
"
Class {
	#name : #WDTextureUsageModeStaticSampled,
	#superclass : #WDTextureUsageMode,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureUsageModeStaticSampled >> isStaticSampled [
	^ true
]
