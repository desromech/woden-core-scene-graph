"
I represent a different camera plane in a scene.
"
Class {
	#name : #WDSceneLayer,
	#superclass : #WDSceneElement,
	#instVars : [
		'scene',
		'nodes'
	],
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

{ #category : #accessing }
WDSceneLayer >> children [
	^ nodes
]

{ #category : #initialization }
WDSceneLayer >> initialize [
	super initialize.
	nodes := OrderedCollection new.
]

{ #category : #initialization }
WDSceneLayer >> initializeWithScene: aScene [
	scene := aScene.
	self initialize.
]

{ #category : #testing }
WDSceneLayer >> isSceneLayer [
	^ true
]

{ #category : #accessing }
WDSceneLayer >> nodes [
	^ nodes
]

{ #category : #accessing }
WDSceneLayer >> parent [
	^ scene
]

{ #category : #accessing }
WDSceneLayer >> scene [
	^ scene
]
