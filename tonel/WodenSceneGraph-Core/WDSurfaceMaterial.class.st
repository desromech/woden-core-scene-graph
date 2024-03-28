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
		'background',
		'xray'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #testing }
WDSurfaceMaterial class >> isAbstract [
	^ self == WDSurfaceMaterial
]

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

{ #category : #accessing }
WDSurfaceMaterial >> effectiveAlphaCutoff [
	^ alphaMode == #MASK ifTrue: [ alphaCutoff ] ifFalse: [ 0.0 ]
]

{ #category : #serializationm }
WDSurfaceMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#alphaMode . alphaMode.
		#doubleSided . doubleSided.
		#alphaCutoff . alphaCutoff.
		#background . background.
		#xray . xray.
	}
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
WDSurfaceMaterial >> hasBackgroundRendering [
	^ background
]

{ #category : #testing }
WDSurfaceMaterial >> hasDepthTesting [
	^ xray not
]

{ #category : #testing }
WDSurfaceMaterial >> hasOpaqueRendering [
	^ self hasAlphaBlending not
]

{ #category : #initialization }
WDSurfaceMaterial >> initialize [
	super initialize.
	xray := false.
	alphaMode := #OPAQUE.
	alphaCutoff := 0.5.
	doubleSided := false.
	background := false.
]

{ #category : #testing }
WDSurfaceMaterial >> isOpaque [
	^ alphaMode == #OPAQUE
]

{ #category : #serializationm }
WDSurfaceMaterial >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	self alphaMode: (jsonData at: #alphaMode ifAbsent: [ alphaMode ]).
	doubleSided := jsonData at: #doubleSided ifAbsent: [ doubleSided ].
	alphaCutoff := jsonData at: #alphaCutoff ifAbsent: [ alphaCutoff ].
	background := jsonData at: #background ifAbsent: [ background ].
	xray := jsonData at: #xray ifAbsent: [ xray ].
]

{ #category : #rendering }
WDSurfaceMaterial >> renderPriority [
	self hasAlphaBlending ifTrue: [ ^ WDRenderPriority translucent ].
	^ background
		ifTrue: [ WDRenderPriority backgroundNoDepth ]
		ifFalse: [ WDRenderPriority default ]
]

{ #category : #'as yet unclassified' }
WDSurfaceMaterial >> withAlphaBlending [
	self alphaMode: #BLEND
]

{ #category : #'as yet unclassified' }
WDSurfaceMaterial >> withAlphaMasking [
	self alphaMode: #MASK
]

{ #category : #testing }
WDSurfaceMaterial >> writesDepth [
	^ background not and: [alphaMode ~~ #BLEND and: [xray not]]
]

{ #category : #accessing }
WDSurfaceMaterial >> xray [

	^ xray
]

{ #category : #accessing }
WDSurfaceMaterial >> xray: aBoolean [
	xray := aBoolean
]
