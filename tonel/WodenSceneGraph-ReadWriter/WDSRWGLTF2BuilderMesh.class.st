Class {
	#name : 'WDSRWGLTF2BuilderMesh',
	#superclass : 'Object',
	#instVars : [
		'name',
		'index',
		'primitives'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'initialization' }
WDSRWGLTF2BuilderMesh >> encodeForJson [
	| nodeDict |
	nodeDict := OrderedDictionary new.
	name ifNotNil: [ nodeDict at: 'name' put: name ].
	nodeDict at: 'primitives' put: (primitives collect: [:each | each encodeForJson]).
	^ nodeDict
	
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMesh >> initialize [
	super initialize.
	primitives := #().
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> primitives [

	^ primitives
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMesh >> primitives: anObject [

	primitives := anObject
]
