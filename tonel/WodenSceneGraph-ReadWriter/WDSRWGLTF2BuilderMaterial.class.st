Class {
	#name : 'WDSRWGLTF2BuilderMaterial',
	#superclass : 'Object',
	#instVars : [
		'name',
		'index',
		'emissiveFactor',
		'emissiveTexture',
		'normalTexture',
		'occlusionTexture'
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

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> emissiveTexture [

	^ emissiveTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> emissiveTexture: anObject [

	emissiveTexture := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderMaterial >> encodeForJson [
	| materialObj |
	materialObj := OrderedDictionary new.
	name ifNotNil: [ 
		materialObj at: 'name' put: name
	].
	normalTexture ifNotNil: [ 
		materialObj at: 'normalTexture' put: (OrderedDictionary new
			at: 'index' put: normalTexture index;
			yourself).
	].
	occlusionTexture ifNotNil: [ 
		materialObj at: 'occlusionTexture' put: (OrderedDictionary new
			at: 'index' put: occlusionTexture index;
			yourself).
	].

	materialObj at: 'emissiveFactor' put: emissiveFactor.
	emissiveTexture ifNotNil: [ 
		materialObj at: 'emissiveTexture' put: (OrderedDictionary new
			at: 'index' put: emissiveTexture index;
			yourself).
	].
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

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> normalTexture [

	^ normalTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> normalTexture: anObject [

	normalTexture := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> occlusionTexture [

	^ occlusionTexture
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderMaterial >> occlusionTexture: anObject [

	occlusionTexture := anObject
]
