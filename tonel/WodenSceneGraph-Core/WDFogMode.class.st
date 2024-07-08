"
I represent a specific fog mode.
"
Class {
	#name : 'WDFogMode',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDFogMode class >> asFogMode [
	^ self uniqueInstance
]

{ #category : 'converting' }
WDFogMode >> asFogMode [
	^ self
]

{ #category : 'converting' }
WDFogMode >> asModeIndex [
	^ self subclassResponsibility	
]

{ #category : 'testing' }
WDFogMode >> isNone [
	^ false
]

{ #category : 'testing' }
WDFogMode >> usesDensity [
	^ false
]
