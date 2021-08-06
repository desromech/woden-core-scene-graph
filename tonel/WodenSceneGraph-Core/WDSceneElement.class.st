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

{ #category : #converting }
WDSceneElement >> asSceneElement [
	^ self
]

{ #category : #accessing }
WDSceneElement >> children [
	self subclassResponsibility
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

{ #category : #testing }
WDSceneElement >> isWodenSceneElement [
	^ true
]

{ #category : #accessing }
WDSceneElement >> parent [
	self subclassResponsibility
]

{ #category : #accessing }
WDSceneElement >> scene [
	^ nil
]

{ #category : #accessing }
WDSceneElement >> sceneLayer [
	^ nil
]
