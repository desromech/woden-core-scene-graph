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
		'visible',
		'localBoundingBox',
		'boundingBox'
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
		renderingSceneCameraLayer addLight: eachLight withGlobalTransform: renderingGlobalTransform
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
WDSceneNode >> asCameraFovY [
	cameras ifEmpty: [ ^ 60.0 ].
	^ cameras first asCameraFovY
]

{ #category : #converting }
WDSceneNode >> asCameraStateWithAspectRatio: aspectRatio [
	cameras isEmpty ifTrue: [ ^ nil ].
	^ (cameras first asCameraStateWithAspectRatio: aspectRatio) copy
		transformation: self globalTransform;
		yourself
]

{ #category : #converting }
WDSceneNode >> asCameraStateWithFrustumTangents: frustumTangents eyeTransform: eyeTransform [
	cameras isEmpty ifTrue: [ ^ nil ].
	^ (cameras first asCameraStateWithFrustumTangents: frustumTangents eyeTransform: eyeTransform) copy
		transformation: (self globalTransform transformTransform: eyeTransform);
		yourself
]

{ #category : #converting }
WDSceneNode >> asSceneNode [
	^ self
]

{ #category : #'as yet unclassified' }
WDSceneNode >> boundingBox [
	^ boundingBox ifNil: [ boundingBox := self localBoundingBox transformedWith: self transform ]
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
	localBoundingBox := nil.
	boundingBox := nil.
	transform := TRSTransform3D new.
]

{ #category : #'as yet unclassified' }
WDSceneNode >> invalidateBoundingBox [
	boundingBox := nil.
	parent ifNotNil: [ parent invalidateChildBoundingBox ]
]

{ #category : #'as yet unclassified' }
WDSceneNode >> invalidateChildBoundingBox [
	self invalidateLocalBoundingBox
]

{ #category : #'as yet unclassified' }
WDSceneNode >> invalidateLocalBoundingBox [
	localBoundingBox := nil.
	self invalidateBoundingBox
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
WDSceneNode >> localBoundingBox [
	localBoundingBox ifNotNil: [ ^ localBoundingBox ].
	localBoundingBox := AABox empty.
	renderables do: [ :each |
		localBoundingBox insertBox: each boundingBox
	].

	lights do: [ :each |
		localBoundingBox insertBox: each boundingBox		
	].

	children do: [ :each |
		localBoundingBox insertBox: each boundingBox		
	].

	^ localBoundingBox
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

{ #category : #copying }
WDSceneNode >> postCopy [
	super postCopy.
	transform := transform copy.
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
	transform rotateDegreesOnX: rotation.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> rotateDegreesOnY: rotation [
	transform rotateDegreesOnY: rotation.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> rotateDegreesOnZ: rotation [
	transform rotateDegreesOnZ: rotation.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnX: rotation [
	transform rotateRadiansOnX: rotation.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnY: rotation [
	transform rotateRadiansOnY: rotation.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> rotateRadiansOnZ: rotation [
	transform rotateRadiansOnZ: rotation.
	self transformChanged
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
WDSceneNode >> transformChanged [
	self invalidateBoundingBox
]

{ #category : #transforming }
WDSceneNode >> translateBy: aVector [
	transform translateBy: aVector.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> translateByX: amount [
	transform translateByX: amount.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> translateByY: amount [
	transform translateByY: amount.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> translateByZ: amount [
	transform translateByZ: amount.
	self transformChanged
]

{ #category : #transforming }
WDSceneNode >> translateToX: x y: y z: z [
	transform translateToX: x y: y z: z.
	self transformChanged
]

{ #category : #accessing }
WDSceneNode >> visible [

	^ visible
]

{ #category : #accessing }
WDSceneNode >> visible: aBoolean [
	visible := aBoolean
]
