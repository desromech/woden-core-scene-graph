"
I am an abstract class for enum like stateless singletons.
"
Class {
	#name : 'WDAbstractEnumClass',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'WodenSceneGraph-Core-Core',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Core'
}

{ #category : 'testing' }
WDAbstractEnumClass class >> isAbstract [
	^ self == WDAbstractEnumClass
]

{ #category : 'instance creation' }
WDAbstractEnumClass class >> new [
	^ self error: 'New is not allowed here.'
]

{ #category : 'accessing' }
WDAbstractEnumClass class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]
