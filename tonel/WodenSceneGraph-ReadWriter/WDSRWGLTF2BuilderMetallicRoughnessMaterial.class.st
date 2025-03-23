Class {
	#name : 'WDSRWGLTF2BuilderMetallicRoughnessMaterial',
	#superclass : 'WDSRWGLTF2BuilderMaterial',
	#instVars : [
		'baseColorFactor',
		'baseColorTexture',
		'roughnessFactor',
		'metallicFactor',
		'metallicRoughnessTexture'
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

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> baseColorTexture [

	^ baseColorTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> baseColorTexture: anObject [

	baseColorTexture := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> encodeForJson [
	| materialObj pbrMaterialObj |
	materialObj := super encodeForJson.
	pbrMaterialObj := OrderedDictionary new.
	materialObj at: 'pbrMetallicRoughness' put: pbrMaterialObj.
	pbrMaterialObj at: 'baseColorFactor' put: baseColorFactor.
	baseColorTexture ifNotNil: [ 
		pbrMaterialObj at: 'baseColorTexture' put: (OrderedDictionary new
			at: 'index' put: baseColorTexture index;
			yourself).
	].
	pbrMaterialObj at: 'metallicFactor' put: metallicFactor.
	pbrMaterialObj at: 'roughnessFactor' put: roughnessFactor.
	metallicRoughnessTexture ifNotNil: [
		pbrMaterialObj at: 'metallicRoughnessTexture' put: (OrderedDictionary new
			at: 'index' put: metallicRoughnessTexture index;
			yourself).
	].
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
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> metallicRoughnessTexture [

	^ metallicRoughnessTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> metallicRoughnessTexture: anObject [

	metallicRoughnessTexture := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> roughnessFactor [

	^ roughnessFactor
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMetallicRoughnessMaterial >> roughnessFactor: anObject [

	roughnessFactor := anObject
]
