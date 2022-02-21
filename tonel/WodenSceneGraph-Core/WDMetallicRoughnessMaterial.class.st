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

{ #category : #accessing }
WDMetallicRoughnessMaterial class >> typeName [
	^ #MetallicRoughness
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

{ #category : #converting }
WDMetallicRoughnessMaterial >> asUnlitMaterial [
	^ WDUnlitMaterial new
		alphaMode: alphaMode;
		alphaCutoff: alphaCutoff;
		doubleSided: doubleSided;
		background: background;
		xray: xray;
		colorFactor: baseColorFactor;
		colorTexture: baseColorTexture;
		yourself
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorFactor [

	^ baseColorFactor
]

{ #category : #accessing }
WDMetallicRoughnessMaterial >> baseColorFactor: aColor [

	baseColorFactor := aColor asVector4
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
WDMetallicRoughnessMaterial >> emissiveFactor: aFactor [
	emissiveFactor := aFactor asVector3
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

{ #category : #serialization }
WDMetallicRoughnessMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#baseColorFactor . baseColorFactor encodeForJSON.
		#baseColorTexture . baseColorTexture ifNotNil: [:texture | texture encodeForJSON].
		#emissiveFactor . emissiveFactor encodeForJSON.
		#emissiveTexture . emissiveTexture ifNotNil: [:texture | texture encodeForJSON].
		#normalTexture . normalTexture ifNotNil: [:texture | texture encodeForJSON].
		#occlusionFactor . occlusionFactor.
		#occlusionTexture . occlusionTexture ifNotNil: [:texture | texture encodeForJSON].
		#metallicFactor . metallicFactor.
		#roughnessFactor . roughnessFactor.
		#metallicRoughnessTexture . metallicRoughnessTexture ifNotNil: [:texture | texture encodeForJSON].

		#texcoordScale . texcoordScale encodeForJSON.
		#texcoordOffset . texcoordOffset encodeForJSON.
		#texcoordOffsetVelocity . texcoordOffsetVelocity encodeForJSON.
	}
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

{ #category : #serialization }
WDMetallicRoughnessMaterial >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	jsonData at: #baseColorFactor ifPresent: [ :found | baseColorFactor := Vector4 loadFromJson: found ].
	jsonData at: #baseColorTexture ifPresent: [ :found | baseColorTexture := WDTexture loadFromJson: found inDirectory: materialDirectory ].
	jsonData at: #emissiveFactor ifPresent: [ :found | emissiveFactor := Vector3 loadFromJson: found ].
	jsonData at: #emissiveTexture ifPresent: [ :found | emissiveTexture := WDTexture loadFromJson: found inDirectory: materialDirectory ].
	jsonData at: #normalTexture ifPresent: [ :found | normalTexture := WDTexture loadNormalMapFromJson: found inDirectory: materialDirectory ].
	occlusionFactor := jsonData at: #occlusionFactor ifAbsent: [occlusionFactor].
	jsonData at: #occlusionTexture ifPresent: [ :found | occlusionTexture := WDTexture loadNonColorFromJson: found inDirectory: materialDirectory ].
	metallicFactor := jsonData at: #metallicFactor ifAbsent: [metallicFactor].
	roughnessFactor := jsonData at: #roughnessFactor ifAbsent: [roughnessFactor].
	jsonData at: #metallicRoughnessTexture ifPresent: [ :found | metallicRoughnessTexture := WDTexture loadNonColorFromJson: found inDirectory: materialDirectory ].
	
	jsonData at: #texcoordScale ifPresent: [ :found | texcoordScale := Vector2 loadFromJson: found ].
	jsonData at: #texcoordOffset ifPresent: [ :found | texcoordOffset := Vector2 loadFromJson: found ].
	jsonData at: #texcoordOffsetVelocity ifPresent: [ :found | texcoordOffsetVelocity := Vector2 loadFromJson: found ].
]

{ #category : #'as yet unclassified' }
WDMetallicRoughnessMaterial >> makeThumbnail [
	baseColorTexture ifNotNil: [ baseColorTexture makeThumbnail ifNotNil: [ :thumb | ^ thumb ] ].
	^ (Form extent: 16@16 depth: 32)
		fillColor: baseColorFactor asColor;
		yourself
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
