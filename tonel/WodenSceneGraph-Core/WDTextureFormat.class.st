"
I represent a specific texture format.
"
Class {
	#name : #WDTextureFormat,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #converting }
WDTextureFormat class >> asTextureFormat [
	^ self uniqueInstance
]

{ #category : #converting }
WDTextureFormat >> asTextureFormat [
	^ self
]

{ #category : #testing }
WDTextureFormat >> isSRGB [
	^ false
]
