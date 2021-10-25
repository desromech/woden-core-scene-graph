Class {
	#name : #WDBinaryBufferAccessorVector4Type,
	#superclass : #WDBinaryBufferAccessorType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferAccessorVector4Type >> componentCount [
	^ 4
]

{ #category : #factory }
WDBinaryBufferAccessorVector4Type >> makeWithComponents: components [
	^ Vector4 x: components first y: components second z: components third w: components fourth
]
