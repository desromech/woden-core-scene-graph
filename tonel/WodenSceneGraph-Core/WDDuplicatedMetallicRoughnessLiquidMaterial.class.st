"
I am metallic roughness material that mixes two duplicated versions of itself that are moving with different velocities. I am typically used as a cheap way to simulate moving water bodies.
"
Class {
	#name : 'WDDuplicatedMetallicRoughnessLiquidMaterial',
	#superclass : 'WDMetallicRoughnessMaterial',
	#instVars : [
		'duplicatedTexcoordScale',
		'duplicatedTexcoordOffset',
		'duplicatedTexcoordOffsetVelocity',
		'mixAlpha'
	],
	#category : 'WodenSceneGraph-Core-Material',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Material'
}

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial class >> typeName [
	^ #DuplicatedMetallicRoughnessLiquid
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordOffset [

	^ duplicatedTexcoordOffset
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordOffset: anObject [

	duplicatedTexcoordOffset := anObject
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordOffsetVelocity [

	^ duplicatedTexcoordOffsetVelocity
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordOffsetVelocity: anObject [

	duplicatedTexcoordOffsetVelocity := anObject
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordScale [

	^ duplicatedTexcoordScale
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> duplicatedTexcoordScale: anObject [

	duplicatedTexcoordScale := anObject
]

{ #category : 'double dispatch' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitDuplicatedMetallicRoughnessLiquidMaterialActivationCommands: self
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#mixAlpha . mixAlpha.
		#duplicatedTexcoordScale . texcoordScale encodeForJSON.
		#duplicatedTexcoordOffset . texcoordOffset encodeForJSON.
		#duplicatedTexcoordOffsetVelocity . texcoordOffsetVelocity encodeForJSON.
	}
]

{ #category : 'initialization' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> initialize [
	super initialize.
	mixAlpha := 0.5.
	duplicatedTexcoordScale := Vector2 ones.
	duplicatedTexcoordOffset := Vector2 zeros.
	duplicatedTexcoordOffsetVelocity := Vector2 zeros.
]

{ #category : 'serialization' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	mixAlpha := (jsonData at: #mixAlpha ifAbsent: [nil]) ifNil: [ mixAlpha ].
	
	jsonData at: #duplicatedTexcoordScale ifPresent: [ :found | duplicatedTexcoordScale := Vector2 loadFromJson: found ].
	jsonData at: #duplicatedTexcoordOffset ifPresent: [ :found | duplicatedTexcoordOffset := Vector2 loadFromJson: found ].
	jsonData at: #duplicatedTexcoordOffsetVelocity ifPresent: [ :found | duplicatedTexcoordOffsetVelocity := Vector2 loadFromJson: found ].
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> mixAlpha [

	^ mixAlpha
]

{ #category : 'accessing' }
WDDuplicatedMetallicRoughnessLiquidMaterial >> mixAlpha: anObject [

	mixAlpha := anObject
]
