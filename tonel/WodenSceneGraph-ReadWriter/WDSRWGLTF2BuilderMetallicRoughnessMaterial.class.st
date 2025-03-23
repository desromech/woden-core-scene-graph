Class {
	#name : 'WDSRWGLTF2BuilderMetallicRoughnessMaterial',
	#superclass : 'WDSRWGLTF2BuilderMaterial',
	#instVars : [
		'baseColorFactor',
		'roughnessFactor',
		'metallicFactor'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> baseColorFactor [

	^ baseColorFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> baseColorFactor: anObject [

	baseColorFactor := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> encodeForJson [
	| materialObj pbrMaterialObj |
	materialObj := super encodeForJson.
	pbrMaterialObj := OrderedDictionary new.
	materialObj at: 'pbrMetallicRoughness' put: pbrMaterialObj.
	pbrMaterialObj at: 'baseColorFactor' put: baseColorFactor.
	pbrMaterialObj at: 'metallicFactor' put: metallicFactor.
	pbrMaterialObj at: 'roughnessFactor' put: roughnessFactor.
	^materialObj
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> metallicFactor [

	^ metallicFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> metallicFactor: anObject [

	metallicFactor := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> roughnessFactor [

	^ roughnessFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> roughnessFactor: anObject [

	roughnessFactor := anObject
]
