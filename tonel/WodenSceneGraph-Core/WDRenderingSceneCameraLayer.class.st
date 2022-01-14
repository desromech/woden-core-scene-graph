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
		'lights'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #adding }
WDRenderingSceneCameraLayer >> addLight: aLightState [
	lights add: aLightState
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

{ #category : #testing }
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
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #testing }
WDRenderingSceneCameraLayer >> sampleCount [
	^ 1
]

{ #category : #accessing }
WDRenderingSceneCameraLayer >> viewMode [
	^ cameraState viewMode
]
