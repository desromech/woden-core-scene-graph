"
I am a binary buffer of data.

I have a direct correspondence to a gltf 2 model binary buffer.
"
Class {
	#name : #WDBinaryBuffer,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'name',
		'data'
	],
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBuffer >> data [

	^ data
]

{ #category : #accessing }
WDBinaryBuffer >> data: anObject [

	data := anObject
]

{ #category : #accessing }
WDBinaryBuffer >> name [

	^ name
]

{ #category : #accessing }
WDBinaryBuffer >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
WDBinaryBuffer >> readStreamFrom: offset withSize: length [
	^ ReadStream on: data from: offset + 1 to: offset + length
]
