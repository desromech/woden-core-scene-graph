Class {
	#name : 'WDSRWGLTF2BuilderNode',
	#superclass : 'Object',
	#instVars : [
		'index',
		'name',
		'children',
		'mesh'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> children [

	^ children
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> children: anObject [

	children := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderNode >> encodeForJson [
	| nodeDict |
	nodeDict := OrderedDictionary new.
	name ifNotNil: [ 
		nodeDict at: 'name' put: name
	].
	mesh ifNotNil: [ 
		nodeDict at: 'mesh' put: mesh index.
	].
	children ifNotEmpty: [ 
		nodeDict at: 'children' put: (children collect: [:each | each index] as: Array )
	].
	^ nodeDict
	
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderNode >> initialize [
	children := #().
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> mesh [

	^ mesh
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> mesh: anObject [

	mesh := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> name: anObject [

	name := anObject
]
