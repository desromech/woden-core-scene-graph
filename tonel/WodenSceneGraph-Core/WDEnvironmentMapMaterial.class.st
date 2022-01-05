"
I am an unlit material that uses an environment map for its texture. I am typically used for implementing sky boxes.
"
Class {
	#name : #WDEnvironmentMapMaterial,
	#superclass : #WDSurfaceMaterial,
	#instVars : [
		'colorFactor',
		'colorTexture'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDEnvironmentMapMaterial >> colorFactor [

	^ colorFactor
]

{ #category : #accessing }
WDEnvironmentMapMaterial >> colorFactor: aColor [

	colorFactor := aColor asVector4
]

{ #category : #accessing }
WDEnvironmentMapMaterial >> colorTexture [

	^ colorTexture
]

{ #category : #accessing }
WDEnvironmentMapMaterial >> colorTexture: anObject [

	colorTexture := anObject
]

{ #category : #'double dispatch' }
WDEnvironmentMapMaterial >> emitActivationCommandsOn: frameRenderer [
	^ frameRenderer emitEnvironmentMapMaterialActivationCommands: self
]

{ #category : #initialization }
WDEnvironmentMapMaterial >> initialize [
	super initialize.
	
	colorFactor := Vector4 ones.
]
