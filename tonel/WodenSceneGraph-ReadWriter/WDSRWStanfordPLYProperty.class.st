"
I represent a property of an element in a PLY model.
"
Class {
	#name : #WDSRWStanfordPLYProperty,
	#superclass : #Object,
	#instVars : [
		'name',
		'index'
	],
	#category : #'WodenSceneGraph-ReadWriter-PLY'
}

{ #category : #'as yet unclassified' }
WDSRWStanfordPLYProperty class >> findPropertyClassFromType: typeName [
	self allSubclassesDo: [ :sc |
		sc typeName = typeName ifTrue: [ ^ sc ]
	].

	self error: 'Failed to find ply property type.'
]

{ #category : #'as yet unclassified' }
WDSRWStanfordPLYProperty class >> typeName [
	^ nil
]

{ #category : #accessing }
WDSRWStanfordPLYProperty >> index [
	^ index
]

{ #category : #accessing }
WDSRWStanfordPLYProperty >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDSRWStanfordPLYProperty >> name [
	^ name
]

{ #category : #accessing }
WDSRWStanfordPLYProperty >> name: anObject [
	name := anObject
]
