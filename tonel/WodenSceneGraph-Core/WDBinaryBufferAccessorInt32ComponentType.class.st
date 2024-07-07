Class {
	#name : 'WDBinaryBufferAccessorInt32ComponentType',
	#superclass : 'WDBinaryBufferAccessorComponentType',
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'reading-writing' }
WDBinaryBufferAccessorInt32ComponentType >> readFromBuffer: buffer at: index [
	^ buffer signedLongAt: index
]

{ #category : 'accessing' }
WDBinaryBufferAccessorInt32ComponentType >> size [
	^ 4
]
