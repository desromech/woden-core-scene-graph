"
I hold the data that is required for actually binding a set of vertex buffers for rendering.
"
Class {
	#name : #WDVertexBufferBinding,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'attributes',
		'vertexCount',
		'locationMask'
	],
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDVertexBufferBinding >> attributes [

	^ attributes
]

{ #category : #accessing }
WDVertexBufferBinding >> attributes: anObject [

	attributes := anObject
]

{ #category : #accessing }
WDVertexBufferBinding >> locationMask [
	locationMask ifNil: [ 
		locationMask := 0.
		attributes do: [ :each |
			locationMask := locationMask bitOr: (1 bitShift: each location)
		]
	].
	^ locationMask
]

{ #category : #accessing }
WDVertexBufferBinding >> validVertexCount [
	^ vertexCount ifNil: [ attributes first accessor count ]
]

{ #category : #accessing }
WDVertexBufferBinding >> vertexCount [

	^ vertexCount
]

{ #category : #accessing }
WDVertexBufferBinding >> vertexCount: anObject [

	vertexCount := anObject
]
