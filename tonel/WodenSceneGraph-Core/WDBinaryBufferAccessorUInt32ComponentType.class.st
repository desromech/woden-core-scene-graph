Class {
	#name : #WDBinaryBufferAccessorUInt32ComponentType,
	#superclass : #WDBinaryBufferAccessorComponentType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'reading-writing' }
WDBinaryBufferAccessorUInt32ComponentType >> readFromBuffer: buffer at: index [
	^ buffer unsignedLongAt: index
]

{ #category : #accessing }
WDBinaryBufferAccessorUInt32ComponentType >> size [
	^ 4
]
