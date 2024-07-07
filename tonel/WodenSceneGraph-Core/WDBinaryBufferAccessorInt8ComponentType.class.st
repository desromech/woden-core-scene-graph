Class {
	#name : 'WDBinaryBufferAccessorInt8ComponentType',
	#superclass : 'WDBinaryBufferAccessorComponentType',
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'reading-writing' }
WDBinaryBufferAccessorInt8ComponentType >> readFromBuffer: buffer at: index [
	^ buffer signedByteAt: index
]

{ #category : 'accessing' }
WDBinaryBufferAccessorInt8ComponentType >> size [
	^ 1
]
