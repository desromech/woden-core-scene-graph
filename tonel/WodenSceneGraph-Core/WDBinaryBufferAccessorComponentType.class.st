"
I represent a component type in a binary buffer accessor.
"
Class {
	#name : #WDBinaryBufferAccessorComponentType,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #converting }
WDBinaryBufferAccessorComponentType class >> asBinaryBufferAccessorComponentType [
	^ self uniqueInstance
]

{ #category : #converting }
WDBinaryBufferAccessorComponentType >> asBinaryBufferAccessorComponentType [
	^ self
]

{ #category : #'reading-writing' }
WDBinaryBufferAccessorComponentType >> readFromBuffer: buffer at: index [
	self subclassResponsibility
]

{ #category : #accessing }
WDBinaryBufferAccessorComponentType >> size [
	self subclassResponsibility
]
