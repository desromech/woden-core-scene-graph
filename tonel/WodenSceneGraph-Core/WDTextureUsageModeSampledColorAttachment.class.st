"
I am the usage mode for a texture that is used rendered into, and then is sampled.
"
Class {
	#name : #WDTextureUsageModeSampledColorAttachment,
	#superclass : #WDTextureUsageMode,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureUsageModeSampledColorAttachment >> isSampledColorAttachment [
	^ true
]
