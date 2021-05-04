Class {
	#name : #WDSurfaceMaterial,
	#superclass : #WDMaterial,
	#instVars : [
		'doubleSided',
		'alphaCutoff',
		'translucent'
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
WDSurfaceMaterial >> doubleSided [

	^ doubleSided
]

{ #category : #accessing }
WDSurfaceMaterial >> doubleSided: anObject [

	doubleSided := anObject
]

{ #category : #accessing }
WDSurfaceMaterial >> translucent [

	^ translucent
]

{ #category : #accessing }
WDSurfaceMaterial >> translucent: anObject [

	translucent := anObject
]
