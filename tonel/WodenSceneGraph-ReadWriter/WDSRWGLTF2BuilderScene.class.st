Class {
	#name : 'WDSRWGLTF2BuilderScene',
	#superclass : 'Object',
	#instVars : [
		'index',
		'name',
		'nodes'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'initialization' }
WDSRWGLTF2BuilderScene >> encodeForJson [
	| json |
	json := OrderedDictionary new.
	name ifNotNil: [ 
		json at: 'name' put: name
	].
	json at: 'nodes' put: (nodes collect: [:each | each index] as: Array).
	^ json
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> nodes [

	^ nodes
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderScene >> nodes: anObject [

	nodes := anObject
]
