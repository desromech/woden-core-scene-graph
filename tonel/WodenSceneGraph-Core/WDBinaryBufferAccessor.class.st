"
I am an accessor for structured data in a binary buffer.

I have a direct correspondence to a gltf 2 model binary buffer accessor.
"
Class {
	#name : #WDBinaryBufferAccessor,
	#superclass : #Object,
	#instVars : [
		'name',
		'bufferView',
		'byteOffset',
		'type',
		'componentType',
		'normalized',
		'count',
		'min',
		'max'
	],
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferAccessor >> bufferView [

	^ bufferView
]

{ #category : #accessing }
WDBinaryBufferAccessor >> bufferView: anObject [

	bufferView := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> byteOffset [

	^ byteOffset
]

{ #category : #accessing }
WDBinaryBufferAccessor >> byteOffset: anObject [

	byteOffset := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> componentType [

	^ componentType
]

{ #category : #accessing }
WDBinaryBufferAccessor >> componentType: aWDBinaryAccessorComponentType [
	componentType := aWDBinaryAccessorComponentType asBinaryBufferAccessorComponentType
]

{ #category : #accessing }
WDBinaryBufferAccessor >> count [

	^ count
]

{ #category : #accessing }
WDBinaryBufferAccessor >> count: anObject [

	count := anObject
]

{ #category : #initialization }
WDBinaryBufferAccessor >> initialize [
	super initialize.
	name := ''.
	byteOffset := 0.
	count := 0.
	normalized := false.
	min := (Array new: 16) atAllPut: 0.
	max := (Array new: 16) atAllPut: 0.

]

{ #category : #accessing }
WDBinaryBufferAccessor >> max [

	^ max
]

{ #category : #accessing }
WDBinaryBufferAccessor >> max: anObject [

	max := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> min [

	^ min
]

{ #category : #accessing }
WDBinaryBufferAccessor >> min: anObject [

	min := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> name [

	^ name
]

{ #category : #accessing }
WDBinaryBufferAccessor >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> normalized [

	^ normalized
]

{ #category : #accessing }
WDBinaryBufferAccessor >> normalized: anObject [

	normalized := anObject
]

{ #category : #accessing }
WDBinaryBufferAccessor >> type [

	^ type
]

{ #category : #accessing }
WDBinaryBufferAccessor >> type: aWDBinaryBufferAccessorType [
	type := aWDBinaryBufferAccessorType asBinaryBufferAccessorType
]
