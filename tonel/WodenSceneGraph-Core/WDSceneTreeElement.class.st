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
WDSceneTreeElement >> add: anObject [
	self addSceneElement: anObject asSceneElement
]

{ #category : #'rendering scene generation' }
WDSceneTreeElement >> addChildrenRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	children do: [ :each |
		each addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform
	]
]

{ #category : #adding }
WDSceneTreeElement >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	self subclassResponsibility
]

{ #category : #adding }
WDSceneTreeElement >> addSceneElement: aNode [
	self assert: aNode isWodenSceneElement.
	self assert: aNode parent isNil.
	
	children add: aNode.
	aNode addedTo: self.
]

{ #category : #internal }
WDSceneTreeElement >> addedTo: newParent [
	self assert: parent isNil.
	parent := newParent.
]

{ #category : #converting }
WDSceneTreeElement >> asRenderingSceneCameraLayerWithCameraState: baseCameraState [
	| result |
	result := WDRenderingSceneCameraLayer new
		cameraState: baseCameraState;
		yourself.
	self addRecursivelyIntoRenderingSceneCameraLayer: result parentGlobalTransform: ReversibleAffineTransform3D identity.
	^ result
]

{ #category : #converting }
WDSceneTreeElement >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		globalLightingState: WDGlobalLightingState defaultForInspector;
		cameraLayers: { 
			self asRenderingSceneCameraLayerWithCameraState: baseCameraState
		};
		yourself.
]

{ #category : #accessing }
WDSceneTreeElement >> children [

	^ children
]

{ #category : #enumerating }
WDSceneTreeElement >> childrenDo: aBlock [
	children do: aBlock
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

{ #category : #copying }
WDSceneTreeElement >> postCopy [
	| oldChildren |
	super postCopy.
	parent := nil.
	oldChildren := children.
	children := OrderedCollection new.
	oldChildren do: [ :each |
		self add: each copy
	].
]

{ #category : #adding }
WDSceneTreeElement >> remove: aNode [
	self removeSceneElement: aNode
]

{ #category : #adding }
WDSceneTreeElement >> removeSceneElement: aNode [
	self assert: aNode isWodenSceneElement.
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
