"
I represent an element int PLY 3D model format.
"
Class {
	#name : 'WDSRWStanfordPLYElement',
	#superclass : 'Object',
	#instVars : [
		'name',
		'count',
		'properties',
		'propertyDictionary',
		'values'
	],
	#category : 'WodenSceneGraph-ReadWriter-PLY',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'PLY'
}

{ #category : 'adding' }
WDSRWStanfordPLYElement >> addProperty: aProperty [
	propertyDictionary at: aProperty name put: aProperty.
	properties add: aProperty.
	aProperty index: properties size.
	
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> count [
	^ count
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> count: anObject [
	count := anObject
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> indexOfProperty: propertyName [
	^ (propertyDictionary at: propertyName) index
]

{ #category : 'initialization' }
WDSRWStanfordPLYElement >> initialize [
	super initialize.
	properties := OrderedCollection new.
	propertyDictionary := Dictionary new.
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> name [
	^ name
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> properties [
	^ properties
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> properties: anObject [
	properties := anObject
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> propertyDictionary [
	^ propertyDictionary
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> values [
	^ values
]

{ #category : 'accessing' }
WDSRWStanfordPLYElement >> values: anObject [
	values := anObject
]
