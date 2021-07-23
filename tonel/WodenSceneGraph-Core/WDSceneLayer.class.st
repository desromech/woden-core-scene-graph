"
I represent a different camera plane in a scene.
"
Class {
	#name : #WDSceneLayer,
	#superclass : #WDSceneTreeElement,
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #'instance creation' }
WDSceneLayer class >> for: aScene [
	^ self basicNew initializeWithScene: aScene
]

{ #category : #testing }
WDSceneLayer class >> isAbstract [
	^ self == WDSceneLayer
]

{ #category : #initialization }
WDSceneLayer >> initializeWithScene: aScene [
	parent := aScene.
	self initialize.
]

{ #category : #testing }
WDSceneLayer >> isSceneLayer [
	^ true
]

{ #category : #accessing }
WDSceneLayer >> scene [
	^ parent
]

{ #category : #'as yet unclassified' }
WDSceneLayer >> sceneLayer [
	^ self
]
