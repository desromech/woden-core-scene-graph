"
I represent an arbitrary element in the logical description of a scene.
"
Class {
	#name : #WDSceneElement,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #testing }
WDSceneElement class >> isAbstract [
	^ self == WDSceneElement
]

{ #category : #accessing }
WDSceneElement >> children [
	self subclassResponsibility
]

{ #category : #accessing }
WDSceneElement >> components [
	^ #()
]

{ #category : #testing }
WDSceneElement >> isBackgroundSceneLayer [
	^ false
]

{ #category : #testing }
WDSceneElement >> isForegroundSceneLayer [
	^ false
]

{ #category : #testing }
WDSceneElement >> isNormalSceneLayer [
	^ false
]

{ #category : #testing }
WDSceneElement >> isScene [
	^ false
]

{ #category : #testing }
WDSceneElement >> isSceneLayer [
	^ false
]

{ #category : #testing }
WDSceneElement >> isSceneNode [
	^ false
]

{ #category : #accessing }
WDSceneElement >> parent [
	self subclassResponsibility
]
