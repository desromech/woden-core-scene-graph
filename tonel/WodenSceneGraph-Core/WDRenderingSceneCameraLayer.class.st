"
I encapsulate a specific state for rendering a scene camera layer. I hold the following data:
- A list of pairs <WDRenderingObjectState, WDRenderablePrimitives> with the list of geometric objects that need to be rendered.
- A list of WDLightState with the lighting state.
- The camera state for the viewport.
"
Class {
	#name : #WDRenderingSceneCameraLayer,
	#superclass : #Object,
	#instVars : [
		'cameraState',
		'renderingObjects',
		'globalLightingState',
		'lights',
		'usesFrustumCulling',
		'isShadowMap',
		'shadowMapCameraLayers',
		'shadowCastingLightSource'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #adding }
WDRenderingSceneCameraLayer >> addLight: aLightState [
	lights add: aLightState
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addLight: light withGlobalTransform: globalTransform [
	light addToRenderingScene: self withGlobalTransform: globalTransform
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addMeshPrimitive: meshPrimitive withMaterial: material objectState: anObjectState [
	self addMeshPrimitive: meshPrimitive
		withPriority: (material ifNil: [ WDRenderPriority default ]
			ifNotNil: [material renderPriority])
		objectState: anObjectState
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addMeshPrimitive: meshPrimitive withPriority: renderPriority objectState: anObjectState [
	renderingObjects add: (WDRenderingSceneObject new
		priority: renderPriority;
		objectState: anObjectState;
		renderable: meshPrimitive;
		yourself)
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addRenderable: renderable withObjectState: anObjectState [
	renderable addToRenderingScene: self withObjectState: anObjectState
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addShadowMapCameraLayer: aCameraLayer [
	shadowMapCameraLayers add: aCameraLayer
]

{ #category : #converting }
WDRenderingSceneCameraLayer >> asRenderingScene [
	^ WDRenderingScene new cameraLayers: { self }; yourself
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> cameraState [

	^ cameraState
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> cameraState: anObject [

	cameraState := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> globalLightingState [
	^ globalLightingState
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> globalLightingState: anObject [

	globalLightingState := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> hasReverseDepth [
	^ cameraState hasReverseDepth
]

{ #category : #initialization }
WDRenderingSceneCameraLayer >> initialize [
	super initialize.
	cameraState := WDCameraState new.
	globalLightingState := WDGlobalLightingState new.
	lights := OrderedCollection new.
	renderingObjects := OrderedCollection new.
	shadowMapCameraLayers := OrderedCollection new.
	usesFrustumCulling := true.
	isShadowMap := false.

]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> isDepthOnly [
	^ isShadowMap
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> isShadowMap [

	^ isShadowMap
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> isShadowMap: anObject [

	isShadowMap := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> lightingState [
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: lights asArray;
		yourself.
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> lightingStateInViewSpace [
	| viewMatrix |
	viewMatrix := cameraState inverseTransformationMatrix.
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: (lights collect: [ :each | each transformedWithMatrix: viewMatrix ]);
		yourself.
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> lightingStateInViewSpaceWithMaxNumberOfLights: maxNumberOfLights [
	| viewMatrix |
	viewMatrix := cameraState inverseTransformationMatrix.
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: ((lights first: (lights size min: maxNumberOfLights)) asArray collect: [ :each |
			each transformedWithMatrix: viewMatrix
		]);
		yourself.
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> lightingStateWithMaxNumberOfLights: maxNumberOfLights [
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: (lights first: (lights size min: maxNumberOfLights)) asArray;
		yourself.
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> lights [

	^ lights
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> renderingObjects [
	^ renderingObjects
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> sampleCount [
	^ 1
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> shadowCastingLightSource [

	^ shadowCastingLightSource
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> shadowCastingLightSource: anObject [

	shadowCastingLightSource := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> shadowCastingLightsDo: aBlock [
	lights do: [ :each |
		each castShadows ifTrue: [
			aBlock value: each
		]
	]
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> shadowMapCameraLayers [
	^ shadowMapCameraLayers
]

{ #category : #testing }
WDRenderingSceneCameraLayer >> shouldRenderBoundingBox: boundingBoxToTest withObjectState: objectState [
	^ usesFrustumCulling
		ifTrue: [ self cameraState worldFrustum intersectsOrContainsBox: (boundingBoxToTest transformedWith: objectState transformation) ]
		ifFalse: [ true ]
]

{ #category : #testing }
WDRenderingSceneCameraLayer >> shouldRenderWorldBoundingBox: boundingBoxToText [
	^ usesFrustumCulling
		ifTrue: [ self cameraState worldFrustum intersectsOrContainsBox: boundingBoxToText ]
		ifFalse: [ true ]
]

{ #category : #testing }
WDRenderingSceneCameraLayer >> shouldRenderWorldSphereWithCenter: sphereCenter radius: sphereRadius [
	^ usesFrustumCulling
		ifTrue: [ self cameraState worldFrustum intersectsOrContainsSphereWithCenter: sphereCenter radius: sphereRadius ]
		ifFalse: [ true ]
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> usesFrustumCulling [

	^ usesFrustumCulling
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> usesFrustumCulling: anObject [

	usesFrustumCulling := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> viewMode [
	^ cameraState viewMode
]
