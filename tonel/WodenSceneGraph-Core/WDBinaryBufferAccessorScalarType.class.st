Class {
	#name : #WDBinaryBufferAccessorScalarType,
	#superclass : #WDBinaryBufferAccessorType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferAccessorScalarType >> componentCount [
	^ 1
]

{ #category : #accessing }
WDBinaryBufferAccessorScalarType >> makeWithComponents: components [
	^ components first
]
