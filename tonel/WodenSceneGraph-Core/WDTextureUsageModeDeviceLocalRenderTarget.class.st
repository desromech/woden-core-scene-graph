"
I am usage mode for a texture that only resides on the device.
"
Class {
	#name : #WDTextureUsageModeDeviceLocalRenderTarget,
	#superclass : #WDTextureUsageMode,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureUsageModeDeviceLocalRenderTarget >> isDeviceLocalRenderTarget [
	^ true
]
