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
WDEnvironmentMapMaterial class >> typeName [
	^ #EnvironmentMap
]

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

{ #category : #serialization }
WDEnvironmentMapMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#colorFactor . colorFactor encodeForJSON.
		#colorTexture . colorTexture ifNotNil: [:texture | texture encodeForJSON]
	}
]

{ #category : #initialization }
WDEnvironmentMapMaterial >> initialize [
	super initialize.
	
	colorFactor := Vector4 ones.
]

{ #category : #serialization }
WDEnvironmentMapMaterial >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	jsonData at: #colorFactor ifPresent: [ :found | colorFactor := Vector4 loadFromJson: found ].
	jsonData at: #colorTexture ifPresent: [ :found | colorTexture := WDTexture loadFromJson: found inDirectory: materialDirectory ].
]
