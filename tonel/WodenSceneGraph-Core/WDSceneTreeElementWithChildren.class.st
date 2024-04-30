Class {
	#name : #WDSceneTreeElementWithChildren,
	#superclass : #WDSceneTreeElement,
	#instVars : [
		'children'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDSceneTreeElementWithChildren >> add: anObject [
	self addSceneElement: anObject asSceneElement
]

{ #category : #adding }
WDSceneTreeElementWithChildren >> addAll: aCollectionOfObjects [
	aCollectionOfObjects do: [ :each | self add: each ]
]

{ #category : #'rendering scene generation' }
WDSceneTreeElementWithChildren >> addChildrenRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	children do: [ :each |
		each addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform
	]
]

{ #category : #adding }
WDSceneTreeElementWithChildren >> addSceneElement: aNode [
	self assert: aNode isWodenSceneElement.
	self assert: aNode parent isNil.
	
	children add: aNode.
	aNode addedTo: self.
]

{ #category : #'as yet unclassified' }
WDSceneTreeElementWithChildren >> childChanged: aChild [
	parent ifNotNil: [ parent childChanged: self ]
]

{ #category : #accessing }
WDSceneTreeElementWithChildren >> children [

	^ children
]

{ #category : #enumerating }
WDSceneTreeElementWithChildren >> childrenDo: aBlock [
	children do: aBlock
]

{ #category : #initialization }
WDSceneTreeElementWithChildren >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #copying }
WDSceneTreeElementWithChildren >> postCopy [
	| oldChildren |
	super postCopy.
	parent := nil.
	oldChildren := children.
	children := OrderedCollection new.
	oldChildren do: [ :each |
		self add: each copy
	].
]

{ #category : #removing }
WDSceneTreeElementWithChildren >> removeAllChildren [
	children do: [ :each | each removedFrom: self ].
	children removeAll
]

{ #category : #adding }
WDSceneTreeElementWithChildren >> removeSceneElement: aNode [
	self assert: aNode isWodenSceneElement.
	self assert: aNode parent == self.
	
	children remove: aNode.
	aNode removedFrom: self.
]
