"
I am a generic scene node. I am used to provide a tree of successive logical transformations, and I can hold an arbitrary number of components.

Each one of these components is further instantiated into a flat non-hierarchical rendering scene element, that allows the usage spatial subdivision structures for fast rendering traversal.
"
Class {
	#name : #WDSceneNode,
	#superclass : #WDSceneTreeElement,
	#instVars : [
		'renderables',
		'transform'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #initialization }
WDSceneNode >> initialize [
	super initialize.
	renderables := #().
	transform := DecomposedTransform3D new.
]

{ #category : #testing }
WDSceneNode >> isSceneNode [
	^ true
]

{ #category : #removing }
WDSceneNode >> removeFromScene [
	parent ifNotNil: [ parent remove: self ]
]

{ #category : #accessing }
WDSceneNode >> renderables [

	^ renderables
]

{ #category : #accessing }
WDSceneNode >> renderables: anObject [

	renderables := anObject
]

{ #category : #accessing }
WDSceneNode >> transform [

	^ transform copy
]

{ #category : #accessing }
WDSceneNode >> transform: aTransform [
	transform := aTransform asDecomposedTransform3D
]
