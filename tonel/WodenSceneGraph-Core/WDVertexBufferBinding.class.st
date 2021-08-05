"
I hold the data that is required for actually binding a set of vertex buffers for rendering.
"
Class {
	#name : #WDVertexBufferBinding,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'attributes',
		'vertexCount'
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
