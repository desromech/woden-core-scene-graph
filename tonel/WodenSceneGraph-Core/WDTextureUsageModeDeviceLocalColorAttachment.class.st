"
I am usage mode for a texture that only resides on the device.
"
Class {
	#name : #WDTextureUsageModeDeviceLocalColorAttachment,
	#superclass : #WDTextureUsageMode,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureUsageModeDeviceLocalColorAttachment >> isDeviceLocalColorAttachment [
	^ true
]
