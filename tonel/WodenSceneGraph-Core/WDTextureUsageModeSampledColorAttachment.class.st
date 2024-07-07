"
I am the usage mode for a texture that is used rendered into, and then is sampled.
"
Class {
	#name : 'WDTextureUsageModeSampledColorAttachment',
	#superclass : 'WDTextureUsageMode',
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'testing' }
WDTextureUsageModeSampledColorAttachment >> isSampledColorAttachment [
	^ true
]
