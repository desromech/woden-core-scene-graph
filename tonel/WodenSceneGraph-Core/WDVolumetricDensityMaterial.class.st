"
I am a volumetric material that uses 3D texture that holds densities.
"
Class {
	#name : #WDVolumetricDensityMaterial,
	#superclass : #WDVolumetricMaterial,
	#instVars : [
		'densityTexture'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDVolumetricDensityMaterial >> densityTexture [

	^ densityTexture
]

{ #category : #accessing }
WDVolumetricDensityMaterial >> densityTexture: anObject [

	densityTexture := anObject
]

{ #category : #'double dispatch' }
WDVolumetricDensityMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitVolumetricDensityMaterialActivationCommands: self
]

{ #category : #rendering }
WDVolumetricDensityMaterial >> renderPriority [
	^ WDRenderPriority translucent
]
