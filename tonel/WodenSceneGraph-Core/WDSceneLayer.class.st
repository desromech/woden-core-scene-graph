"
I represent a different camera plane in a scene.
"
Class {
	#name : #WDSceneLayer,
	#superclass : #WDSceneTreeElement,
	#instVars : [
		'globalLightingState'
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
		globalLightingState: globalLightingState;
		cameraState: adjustedCameraState.
	self addChildrenRecursivelyIntoRenderingSceneCameraLayer: result parentGlobalTransform: ReversibleAffineTransform3D identity.
	^ result
]

{ #category : #converting }
WDSceneLayer >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		cameraLayers: { 
			self asRenderingSceneCameraLayerWithCameraState: baseCameraState
		};
		yourself.
		
		 
]

{ #category : #accessing }
WDSceneLayer >> globalLightingState [

	^ globalLightingState
]

{ #category : #accessing }
WDSceneLayer >> globalLightingState: aWDGlobalLightingState [
	self assert: aWDGlobalLightingState class == WDGlobalLightingState.
	globalLightingState := aWDGlobalLightingState copy.
]

{ #category : #initialization }
WDSceneLayer >> initialize [
	super initialize.
	globalLightingState := WDGlobalLightingState default
]

{ #category : #initialization }
WDSceneLayer >> initializeWithScene: aScene [
	parent := aScene.
	self initialize.
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
