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
