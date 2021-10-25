Class {
	#name : #WDBinaryBufferAccessorUInt16ComponentType,
	#superclass : #WDBinaryBufferAccessorComponentType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'reading-writing' }
WDBinaryBufferAccessorUInt16ComponentType >> readFromBuffer: buffer at: index [
	^ buffer unsignedShortAt: index
]

{ #category : #accessing }
WDBinaryBufferAccessorUInt16ComponentType >> size [
	^ 2
]
