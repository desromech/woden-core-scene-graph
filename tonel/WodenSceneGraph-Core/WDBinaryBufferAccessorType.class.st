"
I represent the type of a binary buffer accessor.
"
Class {
	#name : 'WDBinaryBufferAccessorType',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'converting' }
WDBinaryBufferAccessorType class >> asBinaryBufferAccessorType [
	^ self uniqueInstance
]

{ #category : 'testing' }
WDBinaryBufferAccessorType class >> isAbstract [
	^ self == WDBinaryBufferAccessorType
]

{ #category : 'converting' }
WDBinaryBufferAccessorType >> asBinaryBufferAccessorType [
	^ self
]

{ #category : 'accessing' }
WDBinaryBufferAccessorType >> componentCount [
	^ self subclassResponsibility
]

{ #category : 'factory' }
WDBinaryBufferAccessorType >> makeWithComponents: components [
	self subclassResponsibility
]
