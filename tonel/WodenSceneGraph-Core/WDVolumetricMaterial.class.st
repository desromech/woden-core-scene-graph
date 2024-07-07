"
I am volumetric material.
"
Class {
	#name : 'WDVolumetricMaterial',
	#superclass : 'WDMaterial',
	#category : 'WodenSceneGraph-Core-Material',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Material'
}

{ #category : 'testing' }
WDVolumetricMaterial class >> isAbstract [
	^ self == WDVolumetricMaterial
]

{ #category : 'testing' }
WDVolumetricMaterial >> hasAlphaBlending [
	^ true
]

{ #category : 'testing' }
WDVolumetricMaterial >> hasOpaqueRendering [
	^ false
]
