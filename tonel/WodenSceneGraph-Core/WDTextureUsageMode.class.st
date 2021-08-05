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
WDTextureUsageMode >> isDeviceLocalColorAttachment [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isReadedColorAttachment [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isSampledColorAttachment [
	^ false
]

{ #category : #testing }
WDTextureUsageMode >> isStaticSampled [
	^ false
]
