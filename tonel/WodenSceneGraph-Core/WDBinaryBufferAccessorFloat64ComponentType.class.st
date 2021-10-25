Class {
	#name : #WDBinaryBufferAccessorFloat64ComponentType,
	#superclass : #WDBinaryBufferAccessorComponentType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'reading-writing' }
WDBinaryBufferAccessorFloat64ComponentType >> readFromBuffer: buffer at: index [
	^ buffer doubleAt: index
]

{ #category : #accessing }
WDBinaryBufferAccessorFloat64ComponentType >> size [
	^ 8
]
