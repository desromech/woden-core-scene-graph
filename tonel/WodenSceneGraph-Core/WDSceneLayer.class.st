"
I represent a different camera plane in a scene.
"
Class {
	#name : 'WDSceneLayer',
	#superclass : 'WDSceneTreeElementWithChildren',
	#instVars : [
		'globalLightingState',
		'boundingBox',
		'boundingVolumeTree'
	],
	#category : 'WodenSceneGraph-Core-Scene',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Scene'
}

{ #category : 'instance creation' }
WDSceneLayer class >> for: aScene [
	^ self basicNew initializeWithScene: aScene
]

{ #category : 'testing' }
WDSceneLayer class >> isAbstract [
	^ self == WDSceneLayer
]

{ #category : 'converting' }
WDSceneLayer >> addChildrenRecursivelyIntoRenderingSceneCameraLayerWithFrustumCulling: renderingSceneCameraLayer [
	| parentGlobalTransform frustum |
	parentGlobalTransform := ReversibleAffineTransform3D identity.
	renderingSceneCameraLayer usesFrustumCulling ifFalse: [ 
		children do: [ :each |
			each addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform
		].
		^ self
	].

	frustum := renderingSceneCameraLayer cameraState worldFrustum.
	boundingVolumeTree leavesIntersectingFrustum: frustum do: [ :treeNode |
		treeNode value addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform
	].
]

{ #category : 'adding' }
WDSceneLayer >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	self shouldNotImplement
]

{ #category : 'converting' }
WDSceneLayer >> adjustBaseCameraState: aBaseCameraState [
	^ self subclassResponsibility
]

{ #category : 'converting' }
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

{ #category : 'converting' }
WDSceneLayer >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		globalLightingState: WDGlobalLightingState defaultForInspector;
		cameraLayers: { 
			self asRenderingSceneCameraLayerWithCameraState: baseCameraState
		};
		yourself.
		
		 
]

{ #category : 'converting' }
WDSceneLayer >> asSceneNode [
	^ WDSceneNode new
		addAll: (children collect: [ :each | each copy ]);
		yourself
]

{ #category : 'accessing' }
WDSceneLayer >> boundingBox [
	boundingBox ifNil: [ 
		boundingBox := AABox empty.
		self childrenDo: [ :eachChild |
			| childBox |
			childBox := eachChild boundingBox.
			childBox isInfinite ifFalse: [ 
				boundingBox insertBox: childBox
			].
		]
	].

	^ boundingBox
]

{ #category : 'hook' }
WDSceneLayer >> childBoundingBoxChanged: aChild [
	| childBoundingBox |
	super childBoundingBoxChanged: aChild.
	childBoundingBox := aChild boundingBox.
	aChild boundingVolumeTreeNode ifNotNil: [ 
		boundingVolumeTree updateLeafNode: aChild boundingVolumeTreeNode boundingBox: childBoundingBox.
	].
	
	self invalidateBoundingBox.
]

{ #category : 'initialization' }
WDSceneLayer >> copiedIntoScene: aScene [
	parent := aScene.
]

{ #category : 'initialization' }
WDSceneLayer >> initialize [
	super initialize.
	boundingVolumeTree := WMDbvt new.
]

{ #category : 'initialization' }
WDSceneLayer >> initializeWithScene: aScene [
	parent := aScene.
	self initialize.
]

{ #category : 'copying' }
WDSceneLayer >> instanceAsSceneNode [
	| sceneNode |
	sceneNode := WDSceneNode new.
	self childrenDo: [ :child |
		sceneNode add: child copy
	].
	^ sceneNode
]

{ #category : 'hook' }
WDSceneLayer >> invalidateBoundingBox [
	boundingBox := nil.
]

{ #category : 'testing' }
WDSceneLayer >> isSceneLayer [
	^ true
]

{ #category : 'copying' }
WDSceneLayer >> postCopy [
	boundingVolumeTree := WMDbvt new.
	super postCopy.
	
]

{ #category : 'adding' }
WDSceneLayer >> privateAddChild: aNode [
	self assert: aNode boundingVolumeTreeNode isNil.
	super privateAddChild: aNode.
	
	aNode boundingVolumeTreeNode: (boundingVolumeTree insertValue: aNode withBoundingBox: aNode boundingBox)
]

{ #category : 'adding' }
WDSceneLayer >> privateRemoveChild: aNode [
	self assert: aNode boundingVolumeTreeNode notNil.
	super privateRemoveChild: aNode.
	boundingVolumeTree removeNode: aNode boundingVolumeTreeNode.
	
]

{ #category : 'accessing' }
WDSceneLayer >> scene [
	^ parent
]

{ #category : 'accessing' }
WDSceneLayer >> sceneLayer [
	^ self
]
