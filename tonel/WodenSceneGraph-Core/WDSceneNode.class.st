"
I am a generic scene node. I am used to provide a tree of successive logical transformations, and I can hold an arbitrary number of components.

Each one of these components is further instantiated into a flat non-hierarchical rendering scene element, that allows the usage spatial subdivision structures for fast rendering traversal.
"
Class {
	#name : #WDSceneNode,
	#superclass : #WDSceneElement,
	#instVars : [
		'parent',
		'children',
		'components'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #accessing }
WDSceneNode >> children [

	^ children
]

{ #category : #accessing }
WDSceneNode >> children: anObject [

	children := anObject
]

{ #category : #accessing }
WDSceneNode >> components [

	^ components
]

{ #category : #accessing }
WDSceneNode >> components: anObject [

	components := anObject
]

{ #category : #testing }
WDSceneNode >> isSceneNode [
	^ true
]

{ #category : #accessing }
WDSceneNode >> parent [

	^ parent
]

{ #category : #accessing }
WDSceneNode >> parent: anObject [

	parent := anObject
]
