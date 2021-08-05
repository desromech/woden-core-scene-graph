"
I represent the usage mode of textures which are rendered on the device, and then they are transferred into the host. This is typically used for color attachments that are used in the host.
"
Class {
	#name : #WDTextureUsageModeReadedColorAttachment,
	#superclass : #WDTextureUsageMode,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureUsageModeReadedColorAttachment >> isReadedColorAttachment [
	^ true
]
