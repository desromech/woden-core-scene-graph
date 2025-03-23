Class {
	#name : 'WDSRWGLTF2BuilderMaterial',
	#superclass : 'Object',
	#instVars : [
		'name',
		'index',
		'emissiveFactor'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> emissiveFactor [

	^ emissiveFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> emissiveFactor: anObject [

	emissiveFactor := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMaterial >> encodeForJson [
	| materialObj |
	materialObj := OrderedDictionary new.
	name ifNotNil: [ 
		materialObj at: 'name' put: name
	].
	materialObj at: 'emissiveFactor' put: emissiveFactor.
	^ materialObj
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMaterial >> initialize [
	emissiveFactor := #(0 0 0).
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> name: anObject [

	name := anObject
]
