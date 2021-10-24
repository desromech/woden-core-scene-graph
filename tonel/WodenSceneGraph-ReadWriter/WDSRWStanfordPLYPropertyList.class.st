"
I am a list property. I am used for holding the vertex indices of the faces.
"
Class {
	#name : #WDSRWStanfordPLYPropertyList,
	#superclass : #WDSRWStanfordPLYProperty,
	#instVars : [
		'countType',
		'elementType'
	],
	#category : #'WodenSceneGraph-ReadWriter-PLY'
}

{ #category : #'as yet unclassified' }
WDSRWStanfordPLYPropertyList class >> typeName [
	^ #list
]

{ #category : #accessing }
WDSRWStanfordPLYPropertyList >> countType [
	^ countType
]

{ #category : #accessing }
WDSRWStanfordPLYPropertyList >> countType: anObject [
	countType := anObject
]

{ #category : #accessing }
WDSRWStanfordPLYPropertyList >> elementType [
	^ elementType
]

{ #category : #accessing }
WDSRWStanfordPLYPropertyList >> elementType: anObject [
	elementType := anObject
]

{ #category : #'instance creation' }
WDSRWStanfordPLYPropertyList >> readFrom: inputStream [
	| count |
	count := countType readFrom: inputStream.
	^ (1 to: count) collect: [ :i | elementType readFrom: inputStream ]
]
