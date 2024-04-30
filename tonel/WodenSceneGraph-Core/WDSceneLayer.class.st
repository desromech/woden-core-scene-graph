"
I represent a different camera plane in a scene.
"
Class {
	#name : #WDSceneLayer,
	#superclass : #WDSceneTreeElementWithChildren,
	#instVars : [
		'globalLightingState',
		'boundingBox'
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

{ #category : #converting }
WDSceneLayer >> addChildrenRecursivelyIntoRenderingSceneCameraLayerWithFrustumCulling: renderingSceneCameraLayer [
	| parentGlobalTransform |
	parentGlobalTransform := ReversibleAffineTransform3D identity.
	children do: [ :each |
		(renderingSceneCameraLayer shouldRenderWorldBoundingBox: each boundingBox) ifTrue: [ 
			each addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform
		].
	]
]

{ #category : #adding }
WDSceneLayer >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	self shouldNotImplement
]

{ #category : #converting }
WDSceneLayer >> adjustBaseCameraState: aBaseCameraState [
	^ self subclassResponsibility
]

{ #category : #converting }
WDSceneLayer >> asRenderingSceneCameraLayerWithCameraState: baseCameraState [
	| adjustedCameraState result |
	adjustedCameraState := self adjustBaseCameraState: baseCameraState.
	result := WDRenderingSceneCameraLayer new.
	result
		cameraState: adjustedCameraState.
	self addChildrenRecursivelyIntoRenderingSceneCameraLayerWithFrustumCulling: result.
	
	result shadowCastingLightsDo: [ :eachLight |
		result addRenderingSceneShadowMapSet: (WDRenderingSceneShadowMapSet new
			lightSource: eachLight;
			cameraStates: eachLight shadowMappingCameraStates;
			renderingSceneComputationBlock: [ :lightCameraState |
				| shadowMapCameraLayer|
				shadowMapCameraLayer := WDRenderingSceneCameraLayer new
					cameraState: lightCameraState;
					isShadowMap: true;
					yourself.
				self addChildrenRecursivelyIntoRenderingSceneCameraLayerWithFrustumCulling: shadowMapCameraLayer.
				shadowMapCameraLayer
			];
			yourself
		)
	].

	^ result
]

{ #category : #converting }
WDSceneLayer >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		globalLightingState: WDGlobalLightingState defaultForInspector;
		cameraLayers: { 
			self asRenderingSceneCameraLayerWithCameraState: baseCameraState
		};
		yourself.
		
		 
]

{ #category : #converting }
WDSceneLayer >> asSceneNode [
	^ WDSceneNode new
		addAll: (children collect: [ :each | each copy ]);
		yourself
]

{ #category : #accessing }
WDSceneLayer >> boundingBox [
	boundingBox ifNil: [ 
		boundingBox := AABox empty.
		self childrenDo: [ :eachChild |
			boundingBox insertBox: eachChild boundingBox
		]
	].

	^ boundingBox
]

{ #category : #hook }
WDSceneLayer >> childChanged: aChild [
	super childChanged: aChild.
	self invalidateBoundingBox
]

{ #category : #initialization }
WDSceneLayer >> copiedIntoScene: aScene [
	parent := aScene.
]

{ #category : #initialization }
WDSceneLayer >> initializeWithScene: aScene [
	parent := aScene.
	self initialize.
]

{ #category : #copying }
WDSceneLayer >> instanceAsSceneNode [
	| sceneNode |
	sceneNode := WDSceneNode new.
	self childrenDo: [ :child |
		sceneNode add: child copy
	].
	^ sceneNode
]

{ #category : #hook }
WDSceneLayer >> invalidateBoundingBox [
	boundingBox := nil.
]

{ #category : #hook }
WDSceneLayer >> invalidateChildBoundingBox [
	self invalidateBoundingBox
]

{ #category : #testing }
WDSceneLayer >> isSceneLayer [
	^ true
]

{ #category : #accessing }
WDSceneLayer >> scene [
	^ parent
]

{ #category : #accessing }
WDSceneLayer >> sceneLayer [
	^ self
]
