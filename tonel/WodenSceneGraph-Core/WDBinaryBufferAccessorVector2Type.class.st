Class {
	#name : #WDBinaryBufferAccessorVector2Type,
	#superclass : #WDBinaryBufferAccessorType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferAccessorVector2Type >> componentCount [
	^ 2
]

{ #category : #factory }
WDBinaryBufferAccessorVector2Type >> makeWithComponents: components [
	^ Vector2 x: components first y: components second
]
