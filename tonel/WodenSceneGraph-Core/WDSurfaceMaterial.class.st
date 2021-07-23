"
I am a material that can be applied to polygonal surfaces.
"
Class {
	#name : #WDSurfaceMaterial,
	#superclass : #WDMaterial,
	#instVars : [
		'alphaMode',
		'doubleSided',
		'alphaCutoff'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #accessing }
WDSurfaceMaterial >> alphaCutoff [

	^ alphaCutoff
]

{ #category : #accessing }
WDSurfaceMaterial >> alphaCutoff: anObject [

	alphaCutoff := anObject
]

{ #category : #accessing }
WDSurfaceMaterial >> alphaMode [

	^ alphaMode
]

{ #category : #accessing }
WDSurfaceMaterial >> alphaMode: aModeName [
	alphaMode := aModeName asSymbol
]

{ #category : #accessing }
WDSurfaceMaterial >> doubleSided [

	^ doubleSided
]

{ #category : #accessing }
WDSurfaceMaterial >> doubleSided: anObject [

	doubleSided := anObject
]

{ #category : #testing }
WDSurfaceMaterial >> hasAlphaBlending [
	^ alphaMode == #BLEND
]

{ #category : #testing }
WDSurfaceMaterial >> hasAlphaMasking [
	^ alphaMode == #MASK
]

{ #category : #initialization }
WDSurfaceMaterial >> initialize [
	super initialize.
	alphaMode := #OPAQUE.
	alphaCutoff := 0.5.
	doubleSided := false.
]

{ #category : #testing }
WDSurfaceMaterial >> isOpaque [
	^ alphaMode == #OPAQUE
]
