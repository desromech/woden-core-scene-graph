"
I am a generic scene node. I am used to provide a tree of successive logical transformations, and I can hold an arbitrary number of components.

Each one of these components is further instantiated into a flat non-hierarchical rendering scene element, that allows the usage spatial subdivision structures for fast rendering traversal.
"
Class {
	#name : #WDSceneNode,
	#superclass : #WDSceneTreeElement,
	#instVars : [
		'renderables',
		'lights',
		'transform'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDSceneNode >> addIntoRenderingSceneCameraLayer: renderingSceneCameraLayer withTransform: renderingGlobalTransform [
	renderables isEmpty ifFalse: [ 
		| objectState |
		objectState := WDRenderingObjectState new
			transformation: renderingGlobalTransform;
			yourself.
		renderables do: [ :eachRenderable |
			renderingSceneCameraLayer addRenderable: eachRenderable withObjectState: objectState
		]
	].

	lights do: [ :eachLight |
		renderingSceneCameraLayer addLight: (eachLight asLightStateWithTransform: renderingGlobalTransform)
	].
]

{ #category : #adding }
WDSceneNode >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	| renderingGlobalTransform |
	renderingGlobalTransform := parentGlobalTransform transformTransform: transform asReversibleAffineTransform.
	
	self
		addIntoRenderingSceneCameraLayer: renderingSceneCameraLayer withTransform: renderingGlobalTransform;
		addChildrenRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: renderingGlobalTransform
]

{ #category : #initialization }
WDSceneNode >> initialize [
	super initialize.
	renderables := #().
	lights := #().
	transform := DecomposedTransform3D new.
]

{ #category : #testing }
WDSceneNode >> isSceneNode [
	^ true
]

{ #category : #accessing }
WDSceneNode >> lights [

	^ lights
]

{ #category : #accessing }
WDSceneNode >> lights: anObject [

	lights := anObject
]

{ #category : #accessing }
WDSceneNode >> orientation [
	^ transform orientation
]

{ #category : #accessing }
WDSceneNode >> orientation: anOrientation [
	transform orientation: anOrientation
]

{ #category : #accessing }
WDSceneNode >> position [
	^ transform translation
]

{ #category : #accessing }
WDSceneNode >> position: aPosition [
	transform translation: aPosition
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
WDSceneNode >> scale [
	^ transform scale
]

{ #category : #accessing }
WDSceneNode >> scale: aScale [
	transform scale: aScale
]

{ #category : #accessing }
WDSceneNode >> transform [

	^ transform copy
]

{ #category : #accessing }
WDSceneNode >> transform: aTransform [
	transform := aTransform asDecomposedTransform3D
]
