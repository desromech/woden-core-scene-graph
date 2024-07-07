"
I am a volumetric material that uses 3D texture that holds densities.
"
Class {
	#name : 'WDVolumetricDensityMaterial',
	#superclass : 'WDVolumetricMaterial',
	#instVars : [
		'densityTexture',
		'colorMapTexture',
		'minDensityThreshold',
		'maxDensityThreshold',
		'densityScale',
		'densityBias',
		'minTotalDensity'
	],
	#category : 'WodenSceneGraph-Core-Material',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Material'
}

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> colorMapTexture [

	^ colorMapTexture
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> colorMapTexture: anObject [

	colorMapTexture := anObject
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityBias [

	^ densityBias
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityBias: anObject [

	densityBias := anObject
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityScale [

	^ densityScale
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityScale: anObject [

	densityScale := anObject
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityTexture [

	^ densityTexture
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> densityTexture: anObject [

	densityTexture := anObject
]

{ #category : 'double dispatch' }
WDVolumetricDensityMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitVolumetricDensityMaterialActivationCommands: self
]

{ #category : 'initialization' }
WDVolumetricDensityMaterial >> initialize [
	super initialize.
	minDensityThreshold := 0.0.
	maxDensityThreshold := 1.0.
	densityScale := 1.0.
	densityBias := 0.0.
	minTotalDensity := 0.0.


]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> maxDensityThreshold [

	^ maxDensityThreshold
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> maxDensityThreshold: anObject [

	maxDensityThreshold := anObject
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> minDensityThreshold [

	^ minDensityThreshold
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> minDensityThreshold: anObject [

	minDensityThreshold := anObject
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> minTotalDensity [

	^ minTotalDensity
]

{ #category : 'accessing' }
WDVolumetricDensityMaterial >> minTotalDensity: anObject [

	minTotalDensity := anObject
]

{ #category : 'rendering' }
WDVolumetricDensityMaterial >> renderPriority [
	^ WDRenderPriority translucent
]
