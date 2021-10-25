Class {
	#name : #WDBinaryBufferAccessorUInt8ComponentType,
	#superclass : #WDBinaryBufferAccessorComponentType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'reading-writing' }
WDBinaryBufferAccessorUInt8ComponentType >> readFromBuffer: buffer at: index [
	^ buffer unsignedByteAt: index
]

{ #category : #accessing }
WDBinaryBufferAccessorUInt8ComponentType >> size [
	^ 1
]
