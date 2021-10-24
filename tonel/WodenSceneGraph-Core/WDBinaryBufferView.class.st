"
I am a view for a binary buffer.

I have a direct correspondence to a gltf 2 model binary buffer view.
"
Class {
	#name : #WDBinaryBufferView,
	#superclass : #Object,
	#instVars : [
		'name',
		'buffer',
		'byteOffset',
		'byteLength',
		'byteStride'
	],
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferView >> buffer [

	^ buffer
]

{ #category : #accessing }
WDBinaryBufferView >> buffer: anObject [

	buffer := anObject
]

{ #category : #accessing }
WDBinaryBufferView >> byteLength [

	^ byteLength
]

{ #category : #accessing }
WDBinaryBufferView >> byteLength: anObject [

	byteLength := anObject
]

{ #category : #accessing }
WDBinaryBufferView >> byteOffset [

	^ byteOffset
]

{ #category : #accessing }
WDBinaryBufferView >> byteOffset: anObject [

	byteOffset := anObject
]

{ #category : #accessing }
WDBinaryBufferView >> byteStride [

	^ byteStride
]

{ #category : #accessing }
WDBinaryBufferView >> byteStride: anObject [

	byteStride := anObject
]

{ #category : #initialization }
WDBinaryBufferView >> initialize [
	super initialize.
	name := ''.
	byteOffset := 0.
	byteStride := 0.
	byteLength := 0.
]

{ #category : #accessing }
WDBinaryBufferView >> name [

	^ name
]

{ #category : #accessing }
WDBinaryBufferView >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDBinaryBufferView >> readStream [
	^ buffer readStreamFrom: byteOffset withSize: byteLength
]
