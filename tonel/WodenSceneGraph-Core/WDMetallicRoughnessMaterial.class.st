"
I am a material that uses the metallic-roughness PBR lighting model.

My parameters are taken from the gltf 2.0 spec for model formats.
"
Class {
	#name : #WDMetallicRoughnessMaterial,
	#superclass : #WDSurfaceMaterial,
	#instVars : [
		'baseColorFactor',
		'baseColorTexture',
		'emissiveFactor',
		'emissiveTexture',
		'normalTexture',
		'occlusionFactor',
		'occlusionTexture',
		'metallicFactor',
		'roughnessFactor',
		'metallicRoughnessTexture',
		'texcoordScale',
		'texcoordOffset',
		'texcoordOffsetVelocity'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDMetallicRoughnessMaterial class >> default [
	^ self new
		roughnessFactor: 0.4;
		metallicFactor: 0.0;
		yourself
]

{ #category : #adding }
WDMetallicRoughnessMaterial >> addIntoModelAssetWithDependencies: modelAsset [
	super addIntoModelAssetWithDependencies: modelAsset.
	baseColorTexture ifNotNil: [ modelAsset addTexture: baseColorTexture ].
	emissiveTexture ifNotNil: [ modelAsset addTexture: emissiveTexture ].
	normalTexture ifNotNil: [ modelAsset addTexture: normalTexture ].
	metallicRoughnessTexture ifNotNil: [ modelAsset addTexture: metallicRoughnessTexture ].
	occlusionTexture ifNotNil: [ modelAsset addTexture: occlusionTexture ].
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorFactor [

	^ baseColorFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorFactor: anObject [

	baseColorFactor := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorTexture [

	^ baseColorTexture
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorTexture: anObject [

	baseColorTexture := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> emissiveFactor [

	^ emissiveFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> emissiveFactor: anObject [

	emissiveFactor := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> emissiveTexture [

	^ emissiveTexture
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> emissiveTexture: anObject [

	emissiveTexture := anObject
]

{ #category : #'double dispatch' }
WDMetallicRoughnessMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitMetallicRoughnessMaterialActivationCommands: self
]

{ #category : #initialization }
WDMetallicRoughnessMaterial >> initialize [
	super initialize.
	
	emissiveFactor := Vector3 zeros.
	baseColorFactor := Vector4 ones.
	occlusionFactor := 1.0.
	roughnessFactor := 1.0.
	metallicFactor := 1.0.
	
	texcoordScale := Vector2 ones.
	texcoordOffset := Vector2 zeros.
	texcoordOffsetVelocity := Vector2 zeros.
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> metallicFactor [

	^ metallicFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> metallicFactor: anObject [

	metallicFactor := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> metallicRoughnessTexture [

	^ metallicRoughnessTexture
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> metallicRoughnessTexture: anObject [

	metallicRoughnessTexture := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> normalTexture [

	^ normalTexture
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> normalTexture: anObject [

	normalTexture := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> occlusionFactor [

	^ occlusionFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> occlusionFactor: anObject [

	occlusionFactor := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> occlusionTexture [

	^ occlusionTexture
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> occlusionTexture: anObject [

	occlusionTexture := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> roughnessFactor [

	^ roughnessFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> roughnessFactor: anObject [

	roughnessFactor := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordOffset [

	^ texcoordOffset
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordOffset: anObject [

	texcoordOffset := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordOffsetVelocity [

	^ texcoordOffsetVelocity
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordOffsetVelocity: anObject [

	texcoordOffsetVelocity := anObject
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordScale [

	^ texcoordScale
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> texcoordScale: anObject [

	texcoordScale := anObject
]
