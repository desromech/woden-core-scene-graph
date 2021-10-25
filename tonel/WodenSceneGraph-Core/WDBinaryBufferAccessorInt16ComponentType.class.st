Class {
	#name : #WDBinaryBufferAccessorInt16ComponentType,
	#superclass : #WDBinaryBufferAccessorComponentType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'reading-writing' }
WDBinaryBufferAccessorInt16ComponentType >> readFromBuffer: buffer at: index [
	^ buffer signedShortAt: index
]

{ #category : #accessing }
WDBinaryBufferAccessorInt16ComponentType >> size [
	^ 2
]
