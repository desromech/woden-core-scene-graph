"
I represent a specific texture usage mode.
"
Class {
	#name : #WDTextureUsageMode,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #converting }
WDTextureUsageMode class >> asTextureUsageMode [
	^ self uniqueInstance
]

{ #category : #converting }
WDTextureUsageMode >> asTextureUsageMode [
	^ self
]

{ #category : #testing }
WDTextureUsageMode >> isDeviceLocalRenderTarget [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isReadedRenderTarget [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isSampledRenderTarget [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isStaticSampled [
	^ false
]
