"
I encapsulate a specific state for rendering a scene camera layer. I hold the following data:
- A list of pairs <WDRenderingObjectState, WDRenderablePrimitives> with the list of geometric objects that need to be rendered.
- A list of WDLightState with the lighting state.
- The camera state for the viewport.
"
Class {
	#name : #WDRenderingSceneCameraLayerState,
	#superclass : #Object,
	#instVars : [
		'cameraState',
		'renderingObjects',
		'globalLightingState',
		'lights'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #adding }
WDRenderingSceneCameraLayerState >> addLight: aLightState [
	lights add: aLightState
]

{ #category : #adding }
WDRenderingSceneCameraLayerState >> addMeshPrimitive: meshPrimitive withMaterial: material objectState: anObjectState [
	self addMeshPrimitive: meshPrimitive
		withPriority: (material ifNil: [ WDRenderPriority default ]
			ifNotNil: [material renderPriority])
		objectState: anObjectState
]

{ #category : #adding }
WDRenderingSceneCameraLayerState >> addMeshPrimitive: meshPrimitive withPriority: renderPriority objectState: anObjectState [
	renderingObjects add: (WDRenderingSceneObject new
		priority: renderPriority;
		objectState: anObjectState;
		renderable: meshPrimitive;
		yourself)
]

{ #category : #adding }
WDRenderingSceneCameraLayerState >> addRenderable: renderable withObjectState: anObjectState [
	renderable addToRenderingScene: self withObjectState: anObjectState
]

{ #category : #converting }
WDRenderingSceneCameraLayerState >> asRenderingSceneState [
	^ WDRenderingScene new cameraLayers: { self }; yourself
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> cameraState [

	^ cameraState
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> cameraState: anObject [

	cameraState := anObject
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> globalLightingState [
	^ globalLightingState
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> globalLightingState: anObject [

	globalLightingState := anObject
]

{ #category : #initialization }
WDRenderingSceneCameraLayerState >> initialize [
	super initialize.
	cameraState := WDCameraState new.
	globalLightingState := WDGlobalLightingState new.
	lights := OrderedCollection new.
	renderingObjects := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
WDRenderingSceneCameraLayerState >> lightingStateInViewSpaceWithMaxNumberOfLights: maxNumberOfLights [
	| viewMatrix |
	viewMatrix := cameraState inverseTransformationMatrix.
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: ((lights first: (lights size min: maxNumberOfLights)) asArray collect: [ :each |
			each transformedWithMatrix: viewMatrix
		]);
		yourself.
]

{ #category : #'as yet unclassified' }
WDRenderingSceneCameraLayerState >> lightingStateWithMaxNumberOfLights: maxNumberOfLights [
	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: (lights first: (lights size min: maxNumberOfLights)) asArray;
		yourself.
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> lights [

	^ lights
]

{ #category : #accessing }
WDRenderingSceneCameraLayerState >> renderingObjects [
	^ renderingObjects
]
