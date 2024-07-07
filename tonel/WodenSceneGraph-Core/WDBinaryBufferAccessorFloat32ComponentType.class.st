Class {
	#name : 'WDBinaryBufferAccessorFloat32ComponentType',
	#superclass : 'WDBinaryBufferAccessorComponentType',
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'reading-writing' }
WDBinaryBufferAccessorFloat32ComponentType >> readFromBuffer: buffer at: index [
	^ buffer floatAt: index
]

{ #category : 'accessing' }
WDBinaryBufferAccessorFloat32ComponentType >> size [
	^ 4
]
