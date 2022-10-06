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
		'lights',
		'usesFrustumCulling',
		'isShadowMap',
		'shadowMapSets',
		'opaqueRenderingObjects',
		'translucentRenderingObjects',
		'backgroundObjects'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #adding }
WDRenderingSceneCameraLayer >> addBackgroundRenderingSceneObject: renderingSceneObject [
	backgroundObjects add: renderingSceneObject
	
]

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
	self addMeshPrimitive: meshPrimitive withMaterial: material objectState: anObjectState poseState: nil
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addMeshPrimitive: meshPrimitive withMaterial: material objectState: anObjectState poseState: aPose [
	self addMeshPrimitive: meshPrimitive
		withPriority: (material ifNil: [ WDRenderPriority default ]
			ifNotNil: [material renderPriority])
		opaque: (material ifNil: [ true ] ifNotNil: [material hasOpaqueRendering])
		background: (material ifNil: [ false ] ifNotNil: [material hasBackgroundRendering])
		objectState: anObjectState
		poseState: aPose
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addMeshPrimitive: meshPrimitive withPriority: renderPriority opaque: isOpaque background: isBackground objectState: anObjectState poseState: aPoseState [
	isOpaque ifTrue: [ 
		isBackground ifTrue: [ 
			self addBackgroundRenderingSceneObject: (WDRenderingSceneObject new
				priority: renderPriority;
				objectState: anObjectState;
				renderable: meshPrimitive;
				poseState: aPoseState;
				yourself)
		] ifFalse: [ 
			self addOpaqueRenderingSceneObject: (WDRenderingSceneObject new
				priority: renderPriority;
				objectState: anObjectState;
				renderable: meshPrimitive;
				poseState: aPoseState;
				yourself)
		].
	] ifFalse: [ 
		self addTranslucentRenderingSceneObject: (WDRenderingSceneObject new
			priority: renderPriority;
			objectState: anObjectState;
			renderable: meshPrimitive;
			poseState: aPoseState;
			yourself)
	].

]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addOpaqueRenderingSceneObject: renderingSceneObject [
	opaqueRenderingObjects add: renderingSceneObject
	
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addRenderable: renderable withObjectState: anObjectState [
	renderable addToRenderingScene: self withObjectState: anObjectState
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addRenderingSceneShadowMapSet: shadowMapSet [
	shadowMapSets add: shadowMapSet
]

{ #category : #adding }
WDRenderingSceneCameraLayer >> addTranslucentRenderingSceneObject: renderingSceneObject [
	self isDepthOnly ifFalse: [ 
		translucentRenderingObjects add: renderingSceneObject
	]
	
]

{ #category : #converting }
WDRenderingSceneCameraLayer >> asRenderingScene [
	^ WDRenderingScene new cameraLayers: { self }; yourself
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> backgroundObjects [
	^ backgroundObjects
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
WDRenderingSceneCameraLayer >> hasReverseDepth [
	^ cameraState hasReverseDepth
]

{ #category : #initialization }
WDRenderingSceneCameraLayer >> initialize [
	super initialize.
	cameraState := WDCameraState new.
	lights := OrderedCollection new.
	backgroundObjects := OrderedCollection new.
	opaqueRenderingObjects := OrderedCollection new.
	translucentRenderingObjects := OrderedCollection new.
	shadowMapSets := OrderedCollection new.
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
WDRenderingSceneCameraLayer >> lights [

	^ lights
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> opaqueRenderingObjects [
	^ opaqueRenderingObjects
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> sampleCount [
	^ 1
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
WDRenderingSceneCameraLayer >> shadowMapSets [
	^ shadowMapSets
]

{ #category : #testing }
WDRenderingSceneCameraLayer >> shouldRenderBoundingBox: boundingBoxToTest withObjectState: objectState [
	^ usesFrustumCulling
		ifTrue: [ self cameraState worldFrustum intersectsOrContainsBox: (boundingBoxToTest transformedWith: objectState transformation) ]
		ifFalse: [ true ]
]

{ #category : #testing }
WDRenderingSceneCameraLayer >> shouldRenderBoundingBox: boundingBoxToTest withObjectState: objectState poseState: aPoseState [
	self flag: 'Expand the bounding box to account for deformation size increase.'.
	^ self shouldRenderBoundingBox: boundingBoxToTest withObjectState: objectState
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
WDRenderingSceneCameraLayer >> translucentRenderingObjects [
	^ translucentRenderingObjects
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
