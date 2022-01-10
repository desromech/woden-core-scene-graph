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
		'cameras',
		'transform',
		'visible'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDSceneNode >> addIntoRenderingSceneCameraLayer: renderingSceneCameraLayer withTransform: renderingGlobalTransform [
	visible ifFalse: [ ^ self ].
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
	visible ifFalse: [ ^ self ].
	renderingGlobalTransform := parentGlobalTransform transformTransform: transform asReversibleAffineTransform.
	
	self
		addIntoRenderingSceneCameraLayer: renderingSceneCameraLayer withTransform: renderingGlobalTransform;
		addChildrenRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: renderingGlobalTransform
]

{ #category : #converting }
WDSceneNode >> asCameraStateWithAspectRatio: aspectRatio [
	cameras isEmpty ifTrue: [ ^ nil ].
	^ (cameras first asCameraStateWithAspectRatio: aspectRatio) copy
		transformation: self globalTransform;
		yourself
]

{ #category : #converting }
WDSceneNode >> asSceneNode [
	^ self
]

{ #category : #accessing }
WDSceneNode >> cameras [

	^ cameras
]

{ #category : #accessing }
WDSceneNode >> cameras: anObject [

	cameras := anObject
]

{ #category : #accessing }
WDSceneNode >> globalTransform [
	^ parent
		ifNil: [ transform asReversibleAffineTransform]
		ifNotNil: [ parent globalTransform transformTransform: transform asReversibleAffineTransform ]
]

{ #category : #initialization }
WDSceneNode >> initialize [
	super initialize.
	renderables := #().
	lights := #().
	cameras := #().
	visible := true.
	transform := TRSTransform3D new.
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
	^ transform rotation
]

{ #category : #accessing }
WDSceneNode >> orientation: anOrientation [
	transform rotation: anOrientation
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

{ #category : #transforming }
WDSceneNode >> rotateDegreesOnX: rotation [
	transform rotateDegreesOnX: rotation
]

{ #category : #transforming }
WDSceneNode >> rotateDegreesOnY: rotation [
	transform rotateDegreesOnY: rotation
]

{ #category : #transforming }
WDSceneNode >> rotateDegreesOnZ: rotation [
	transform rotateDegreesOnZ: rotation
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnX: rotation [
	transform rotateRadiansOnX: rotation
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnY: rotation [
	transform rotateRadiansOnY: rotation
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnZ: rotation [
	transform rotateRadiansOnZ: rotation
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
	transform := aTransform asTRSTransform3D
]

{ #category : #transforming }
WDSceneNode >> translateBy: aVector [
	transform translateBy: aVector
]

{ #category : #transforming }
WDSceneNode >> translateByX: amount [
	transform translateByX: amount
]

{ #category : #transforming }
WDSceneNode >> translateByY: amount [
	transform translateByY: amount
]

{ #category : #transforming }
WDSceneNode >> translateByZ: amount [
	transform translateByZ: amount
]

{ #category : #transforming }
WDSceneNode >> translateToX: x y: y z: z [
	transform translateToX: x y: y z: z
]

{ #category : #accessing }
WDSceneNode >> visible [

	^ visible
]

{ #category : #accessing }
WDSceneNode >> visible: aBoolean [
	visible := aBoolean
]
