"
I represent a specific texture type.
"
Class {
	#name : #WDTextureType,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #converting }
WDTextureType class >> asTextureType [
	^ self uniqueInstance
]

{ #category : #converting }
WDTextureType >> asTextureType [
	^ self
]

{ #category : #testing }
WDTextureType >> is1DTextureType [
	^ false
]

{ #category : #testing }
WDTextureType >> is2DTextureType [
	^ false
]

{ #category : #testing }
WDTextureType >> is3DTextureType [
	^ false
]

{ #category : #testing }
WDTextureType >> isCubeTextureType [
	^ false
]

{ #category : #testing }
WDTextureType >> isUnknownTextureType [
	^ false
]
