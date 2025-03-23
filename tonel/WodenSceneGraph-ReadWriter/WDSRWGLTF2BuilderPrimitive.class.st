Class {
	#name : 'WDSRWGLTF2BuilderPrimitive',
	#superclass : 'Object',
	#instVars : [
		'attributes',
		'indices',
		'material'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderPrimitive >> attributes [

	^ attributes
]

{ #category : 'as yet unclassified' }
WDSRWGLTF2BuilderPrimitive >> encodeForJson [
	| result attributesObj |
	result := OrderedDictionary new.
	attributesObj := OrderedDictionary new.
	
	attributes keysAndValuesDo: [ :key :value |
		attributesObj at: key put: value index
	].
	result at: 'attributes' put: attributesObj.
	indices  ifNotNil: [ 
		result at: 'indices' put: indices index.
	].
	material ifNotNil: [ 
		result at: 'material' put: material index.
	].
	^ result
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderPrimitive >> indices [

	^ indices
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderPrimitive >> indices: anObject [

	indices := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderPrimitive >> initialize [
	attributes := OrderedDictionary new.
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderPrimitive >> material [

	^ material
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderPrimitive >> material: anObject [

	material := anObject
]
