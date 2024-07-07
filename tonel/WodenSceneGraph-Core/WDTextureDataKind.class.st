"
I specify the data kind of a texture. I am typically used for automatically selecting the correct algorithm for automatic mipmap generation.
"
Class {
	#name : 'WDTextureDataKind',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'converting' }
WDTextureDataKind class >> asTextureDataKind [
	^ self uniqueInstance
]

{ #category : 'converting' }
WDTextureDataKind >> asTextureDataKind [
	^ self
]

{ #category : 'testing' }
WDTextureDataKind >> isColorData [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isCubeEnvironmentMapData [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isDiffuseLightProbe [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isHDRIData [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isNonColorData [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isNormalMapData [
	^ false
]

{ #category : 'testing' }
WDTextureDataKind >> isSpecularLightProbe [
	^ false
]
