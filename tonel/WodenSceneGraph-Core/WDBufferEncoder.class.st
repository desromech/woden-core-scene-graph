"
I am an utility class for encoding binary buffer data.
"
Class {
	#name : #WDBufferEncoder,
	#superclass : #Object,
	#instVars : [
		'segments',
		'dataSize'
	],
	#category : #'WodenSceneGraph-Core-RenderableBuilder'
}

{ #category : #adding }
WDBufferEncoder >> addByteArray: aSequence [
	self privateAddByteArray: aSequence asByteArray
]

{ #category : #adding }
WDBufferEncoder >> addFloat32Array: aSequence [
	| data |
	data := aSequence asFloatArray shallowCopy.
	ByteArray adoptInstance: data.
	self privateAddByteArray: data
]

{ #category : #adding }
WDBufferEncoder >> addInt32Array: aSequence [
	| data |
	data := aSequence asIntegerArray shallowCopy.
	ByteArray adoptInstance: data.
	self privateAddByteArray: data
]

{ #category : #adding }
WDBufferEncoder >> addUInt16Array: aSequence [
	| data destIndex |
	data := ByteArray new: aSequence size * 2.
	destIndex := 1.
	aSequence do: [ :each |
		data unsignedShortAt: destIndex put: each.
		destIndex := destIndex + 2
	].
	
	self privateAddByteArray: data
]

{ #category : #adding }
WDBufferEncoder >> addUInt32Array: aSequence [
	| data |
	data := aSequence asWordArray shallowCopy.
	ByteArray adoptInstance: data.
	self privateAddByteArray: data
]

{ #category : #private }
WDBufferEncoder >> alignTo: alignment [
	| newSize paddingSize |
	newSize := dataSize alignedTo: alignment.
	paddingSize := newSize - dataSize.
	paddingSize > 0 ifTrue: [ 
		self privateAddByteArray: (ByteArray new: paddingSize)
	]
]

{ #category : #builder }
WDBufferEncoder >> finish [
	| result destIndex |
	result := ByteArray new: dataSize.
	destIndex := 1.
	segments do: [ :each |
		| segmentSize |
		segmentSize := each size.
		result replaceFrom: destIndex to: destIndex + segmentSize - 1 with: each startingAt: 1.
		destIndex := destIndex + segmentSize
	].
	^ result
]

{ #category : #initialization }
WDBufferEncoder >> initialize [
	super initialize.
	segments := OrderedCollection new.
	self reset
]

{ #category : #private }
WDBufferEncoder >> privateAddByteArray: newSegment [
	newSegment isEmpty ifTrue: [ ^ self ].
	dataSize := dataSize + newSegment size.
	segments add: newSegment
]

{ #category : #initialization }
WDBufferEncoder >> reset [
	dataSize := 0.
	segments removeAll.
]

{ #category : #accessing }
WDBufferEncoder >> size [
	^ dataSize
]
