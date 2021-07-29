"
A WDBufferEncoderTest is a test class for testing the behavior of WDBufferEncoder
"
Class {
	#name : #WDBufferEncoderTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-RenderableBuilder'
}

{ #category : #tests }
WDBufferEncoderTest >> testAddFloatArray [
	| encoded |
	encoded := WDBufferEncoder new
		addFloat32Array: { 42.5 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 4.
	self assert: (encoded floatAt: 1) equals: 42.5.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddFloatArray2 [
	| encoded |
	encoded := WDBufferEncoder new
		addFloat32Array: { 42.5 . 2.5 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 8.
	self assert: (encoded floatAt: 1) equals: 42.5.
	self assert: (encoded floatAt: 5) equals: 2.5.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddInt32Array [
	| encoded |
	encoded := WDBufferEncoder new
		addInt32Array: { -42 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 4.
	self assert: (encoded signedLongAt: 1) equals: -42.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddInt32Array2 [
	| encoded |
	encoded := WDBufferEncoder new
		addInt32Array: { -42 . 1 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 8.
	self assert: (encoded signedLongAt: 1) equals: -42.
	self assert: (encoded signedLongAt: 5) equals: 1.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddUInt16Array [
	| encoded |
	encoded := WDBufferEncoder new
		addUInt16Array: { 42 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 2.
	self assert: (encoded unsignedShortAt: 1) equals: 42.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddUInt16Array2 [
	| encoded |
	encoded := WDBufferEncoder new
		addUInt16Array: { 42 . 1 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 4.
	self assert: (encoded unsignedShortAt: 1) equals: 42.
	self assert: (encoded unsignedShortAt: 3) equals: 1.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddUInt32Array [
	| encoded |
	encoded := WDBufferEncoder new
		addUInt32Array: { 42 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 4.
	self assert: (encoded unsignedLongAt: 1) equals: 42.
]

{ #category : #tests }
WDBufferEncoderTest >> testAddUInt32Array2 [
	| encoded |
	encoded := WDBufferEncoder new
		addUInt32Array: { 42 . 1 };
		finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded size equals: 8.
	self assert: (encoded unsignedLongAt: 1) equals: 42.
	self assert: (encoded unsignedLongAt: 5) equals: 1.
]

{ #category : #tests }
WDBufferEncoderTest >> testEmpty [
	| encoded |
	encoded := WDBufferEncoder new finish.
	self assert: encoded class equals: ByteArray.
	self assert: encoded isEmpty.
]

{ #category : #tests }
WDBufferEncoderTest >> testSize [
	| encoded encoder |
	encoder := WDBufferEncoder new.
	self assert: encoder size equals: 0.
	
	encoder addInt32Array: {1}.
	self assert: encoder size equals: 4.
	encoder alignTo: 16.
	self assert: encoder size equals: 16.

	encoded := encoder addFloat32Array: { 2 . 3 }.
	self assert: encoder size equals: 24.
	
	encoded := encoder finish.
	self assert: encoded size equals: 24.
	self assert: (encoded signedLongAt: 1) equals: 1.
	self assert: (encoded floatAt: 17) equals: 2.0.
	self assert: (encoded floatAt: 21) equals: 3.0.
]
