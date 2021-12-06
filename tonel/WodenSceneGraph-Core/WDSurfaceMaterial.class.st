"
I am a material that can be applied to polygonal surfaces.
"
Class {
	#name : #WDSurfaceMaterial,
	#superclass : #WDMaterial,
	#instVars : [
		'alphaMode',
		'doubleSided',
		'alphaCutoff',
		'background'
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
WDSurfaceMaterial >> background [

	^ background
]

{ #category : #accessing }
WDSurfaceMaterial >> background: anObject [

	background := anObject
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

{ #category : #testing }
WDSurfaceMaterial >> hasDepthTesting [
	^ background not and: [alphaMode ~~ #BLEND]
]

{ #category : #initialization }
WDSurfaceMaterial >> initialize [
	super initialize.
	alphaMode := #OPAQUE.
	alphaCutoff := 0.5.
	doubleSided := false.
	background := false.
]

{ #category : #testing }
WDSurfaceMaterial >> isOpaque [
	^ alphaMode == #OPAQUE
]

{ #category : #rendering }
WDSurfaceMaterial >> renderPriority [
	self hasAlphaBlending ifTrue: [ ^ WDRenderPriority translucent ].
	^ background
		ifTrue: [ WDRenderPriority backgroundNoDepth ]
		ifFalse: [ WDRenderPriority default ]
]
