"
I am a scene node which is asynchronously loaded. I might be loaded from either disk or even network.
"
Class {
	#name : 'WDAsyncSceneNode',
	#superclass : 'WDSceneTreeElement',
	#instVars : [
		'visible',
		'transform',
		'uri',
		'asyncContext',
		'elementSelector',
		'sceneNodeFuture',
		'fallbackNode',
		'boundingBox',
		'hasSolvedSceneNode'
	],
	#category : 'WodenSceneGraph-Core-Scene',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Scene'
}

{ #category : 'adding' }
WDAsyncSceneNode >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	visible ifFalse: [ ^ self ].
	
	self currentRenderingSceneNode ifNotNil: [ :renderingNode |
		| renderingGlobalTransform |
		renderingGlobalTransform := parentGlobalTransform transformTransform: transform asReversibleAffineTransform.
		renderingNode addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: renderingGlobalTransform
	]
]

{ #category : 'accessing' }
WDAsyncSceneNode >> asyncContext [

	^ asyncContext
]

{ #category : 'accessing' }
WDAsyncSceneNode >> asyncContext: anObject [

	asyncContext := anObject
]

{ #category : 'accessing' }
WDAsyncSceneNode >> boundingBox [
	^ boundingBox ifNil: [ boundingBox := self localBoundingBox transformedWith: self transform ]
]

{ #category : 'accessing' }
WDAsyncSceneNode >> children [
	self solvedSceneNode ifNotNil: [ :solvedNode | ^ { solvedNode } ].
	fallbackNode ifNotNil: [ ^ { fallbackNode } ].
	^ #()
]

{ #category : 'accessing' }
WDAsyncSceneNode >> currentRenderingSceneNode [
	^ self solvedSceneNode ifNil: [ fallbackNode ]
]

{ #category : 'accessing' }
WDAsyncSceneNode >> elementSelector [

	^ elementSelector
]

{ #category : 'accessing' }
WDAsyncSceneNode >> elementSelector: anObject [

	elementSelector := anObject
]

{ #category : 'initialization' }
WDAsyncSceneNode >> initialize [
	super initialize.
	visible := true.
	transform := TRSTransform3D identity.
	boundingBox := nil.
	hasSolvedSceneNode := false.
]

{ #category : 'accessing' }
WDAsyncSceneNode >> invalidateBoundingBox [
	boundingBox := nil.
	parent ifNotNil: [ parent childBoundingBoxChanged: self ]
]

{ #category : 'accessing' }
WDAsyncSceneNode >> localBoundingBox [
	^ self currentRenderingSceneNode
		ifNil: [ AABox empty ]
		ifNotNil: [ :renderingNode | renderingNode boundingBox ].
]

{ #category : 'accessing' }
WDAsyncSceneNode >> postCopy [
	super postCopy.
	transform := transform copy.
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateDegreesOnX: rotation [
	transform rotateDegreesOnX: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateDegreesOnY: rotation [
	transform rotateDegreesOnY: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateDegreesOnZ: rotation [
	transform rotateDegreesOnZ: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateRadiansOnX: rotation [
	transform rotateRadiansOnX: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateRadiansOnY: rotation [
	transform rotateRadiansOnY: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> rotateRadiansOnZ: rotation [
	transform rotateRadiansOnZ: rotation.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> scale [
	^ transform scale
]

{ #category : 'accessing' }
WDAsyncSceneNode >> scale: aScale [
	transform scale: aScale.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> solvedSceneNode [
	^ self validSceneNodeFuture ifNotNil: [
		sceneNodeFuture valueOrNil ifNotNil: [ :result |
			hasSolvedSceneNode ifFalse: [
				self invalidateBoundingBox.
				hasSolvedSceneNode := true
			].
			
			result
		]
	]
]

{ #category : 'accessing' }
WDAsyncSceneNode >> transform [

	^ transform copy
]

{ #category : 'accessing' }
WDAsyncSceneNode >> transform: aTransform [
	transform := aTransform asTRSTransform3D.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> transformChanged [
	self invalidateBoundingBox
]

{ #category : 'accessing' }
WDAsyncSceneNode >> translateBy: aVector [
	transform translateBy: aVector.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> translateByX: amount [
	transform translateByX: amount.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> translateByY: amount [
	transform translateByY: amount.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> translateByZ: amount [
	transform translateByZ: amount.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> translateToX: x y: y z: z [
	transform translateToX: x y: y z: z.
	self transformChanged
]

{ #category : 'accessing' }
WDAsyncSceneNode >> uri [

	^ uri
]

{ #category : 'accessing' }
WDAsyncSceneNode >> uri: anObject [

	uri := anObject
]

{ #category : 'accessing' }
WDAsyncSceneNode >> validSceneNodeFuture [
	sceneNodeFuture ifNil: [ 
		asyncContext ifNotNil: [
			sceneNodeFuture := asyncContext enqueueLoadingModelAssetURI: uri thenDo: [ :loadedModelAsset |
				loadedModelAsset ifNotNil: [loadedModelAsset instanceSceneNodeForElementNamed: elementSelector ]
			]
		]
	].

	^ sceneNodeFuture
]

{ #category : 'accessing' }
WDAsyncSceneNode >> visible [

	^ visible
]

{ #category : 'accessing' }
WDAsyncSceneNode >> visible: anObject [

	visible := anObject
]
