"
I am an utility for reading or writing a model asset.
"
Class {
	#name : #WDModelAssetReadWriter,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-Asset'
}

{ #category : #factory }
WDModelAssetReadWriter class >> extensions [
	^ #()
]

{ #category : #factory }
WDModelAssetReadWriter class >> forExtension: anExtension [
	self withAllSubclassesDo: [ :sc |
		(sc supportsExtension: anExtension) ifTrue: [
			^ sc
		]
	].
	^ nil
]

{ #category : #'read/write usage' }
WDModelAssetReadWriter class >> readFileNamed: aFileName [
	| fileReference extension readWriter |
	fileReference := aFileName asFileReference.
	extension := fileReference extension asLowercase.
	readWriter := (self forExtension: extension) ifNil: [ 
		self error: 'No model asset read writer available for extension ' , extension.
	].

	^ readWriter readFromFileReference: fileReference
]

{ #category : #'read/write usage' }
WDModelAssetReadWriter class >> readFromFileReference: aFileReference [
	self subclassResponsibility
]

{ #category : #factory }
WDModelAssetReadWriter class >> supportsExtension: anExtension [
	^ self extensions includes: anExtension
]
