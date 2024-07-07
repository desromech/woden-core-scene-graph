Class {
	#name : 'WDBinaryBufferAccessorVector3Type',
	#superclass : 'WDBinaryBufferAccessorType',
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'accessing' }
WDBinaryBufferAccessorVector3Type >> componentCount [
	^ 3
]

{ #category : 'factory' }
WDBinaryBufferAccessorVector3Type >> makeWithComponents: components [
	^ Vector3 x: components first y: components second z: components third
]
