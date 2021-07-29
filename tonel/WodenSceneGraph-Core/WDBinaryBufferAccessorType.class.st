"
I represent the type of a binary buffer accessor.
"
Class {
	#name : #WDBinaryBufferAccessorType,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #converting }
WDBinaryBufferAccessorType class >> asBinaryBufferAccessorType [
	^ self uniqueInstance
]

{ #category : #testing }
WDBinaryBufferAccessorType class >> isAbstract [
	^ self == WDBinaryBufferAccessorType
]

{ #category : #converting }
WDBinaryBufferAccessorType >> asBinaryBufferAccessorType [
	^ self
]
