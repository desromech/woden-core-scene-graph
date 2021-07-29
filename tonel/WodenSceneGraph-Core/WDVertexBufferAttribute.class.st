"
I am a specific attribute in a vertex buffer.
"
Class {
	#name : #WDVertexBufferAttribute,
	#superclass : #Object,
	#instVars : [
		'location',
		'accessor'
	],
	#classVars : [
		'BoneIndicesLocation',
		'BoneWeightsLocation',
		'ColorLocation',
		'NormalLocation',
		'PositionLocation',
		'Tangent4Location',
		'Texcoord2Location',
		'TexcoordLocation'
	],
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> boneIndicesLocation [
	^ BoneIndicesLocation
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> boneWeightsLocation [
	^ BoneWeightsLocation
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> colorLocation [
	^ ColorLocation
]

{ #category : #initialization }
WDVertexBufferAttribute class >> initialize [
	PositionLocation := 0.
	ColorLocation := 1.
	NormalLocation := 2.
	TexcoordLocation := 3.
	Texcoord2Location := 4.
	BoneIndicesLocation := 5.
	BoneWeightsLocation := 6.
	Tangent4Location := 7.
	
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> normalLocation [
	^ NormalLocation
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> positionLocation [
	^ PositionLocation
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> tangent4Location [
	^ Tangent4Location
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> texcoord2Location [
	^ Texcoord2Location
]

{ #category : #'vertex attribute locations' }
WDVertexBufferAttribute class >> texcoordLocation [
	^ TexcoordLocation
]

{ #category : #accessing }
WDVertexBufferAttribute >> accessor [

	^ accessor
]

{ #category : #accessing }
WDVertexBufferAttribute >> accessor: anObject [

	accessor := anObject
]

{ #category : #accessing }
WDVertexBufferAttribute >> location [

	^ location
]

{ #category : #accessing }
WDVertexBufferAttribute >> location: anObject [

	location := anObject
]
