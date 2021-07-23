"
I am a hierarchical scene element that implements methods for manipulating its tree.
"
Class {
	#name : #WDSceneTreeElement,
	#superclass : #WDSceneElement,
	#instVars : [
		'parent',
		'children'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDSceneTreeElement >> add: aNode [
	self assert: aNode parent isNil.
	
	children add: aNode.
	aNode addedTo: self.
]

{ #category : #internal }
WDSceneTreeElement >> addedTo: newParent [
	self assert: parent isNil.
	parent := newParent.
]

{ #category : #accessing }
WDSceneTreeElement >> children [

	^ children
]

{ #category : #initialization }
WDSceneTreeElement >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #accessing }
WDSceneTreeElement >> parent [

	^ parent
]

{ #category : #accessing }
WDSceneTreeElement >> parent: anObject [

	parent := anObject
]

{ #category : #adding }
WDSceneTreeElement >> remove: aNode [
	self assert: aNode parent == self.
	
	children remove: aNode.
	aNode removedFrom: self.
]

{ #category : #internal }
WDSceneTreeElement >> removedFrom: oldParent [
	self assert: parent == oldParent.
	parent := nil.
]

{ #category : #internal }
WDSceneTreeElement >> scene [
	^ parent ifNotNil: [ parent scene ]
]

{ #category : #internal }
WDSceneTreeElement >> sceneLayer [
	^ parent ifNotNil: [ parent sceneLayer ]
]
