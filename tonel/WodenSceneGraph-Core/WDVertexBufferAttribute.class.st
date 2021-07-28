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
	#category : #'WodenSceneGraph-Core-Resources'
}

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
