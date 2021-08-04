"
I encapsulate a specific state for rendering a scene. I hold the following data:
- A list of pairs <WDRenderingObjectState, WDRenderablePrimitives> with the list of geometric objects that need to be rendered.
- A list of WDLightState with the lighting state.
- The camera state for the viewport.
"
Class {
	#name : #WDRenderingSceneState,
	#superclass : #Object,
	#instVars : [
		'cameraState',
		'renderingObjects',
		'lights'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #adding }
WDRenderingSceneState >> addMeshPrimitive: meshPrimitive withMaterial: material objectState: anObjectState [
	self addMeshPrimitive: meshPrimitive
		withPriority: (material ifNil: [ WDRenderPriority default ]
			ifNotNil: [material renderPriority])
		objectState: anObjectState
]

{ #category : #adding }
WDRenderingSceneState >> addMeshPrimitive: meshPrimitive withPriority: renderPriority objectState: anObjectState [
	renderingObjects add: (WDRenderingSceneObject new
		priority: renderPriority;
		renderable: meshPrimitive;
		yourself)
]

{ #category : #adding }
WDRenderingSceneState >> addRenderable: renderable withObjectState: anObjectState [
	renderable addToRenderingScene: self withObjectState: anObjectState
]

{ #category : #accessing }
WDRenderingSceneState >> cameraState [

	^ cameraState
]

{ #category : #accessing }
WDRenderingSceneState >> cameraState: anObject [

	cameraState := anObject
]

{ #category : #initialization }
WDRenderingSceneState >> initialize [
	super initialize.
	cameraState := WDCameraState new.
	lights := OrderedCollection new.
	renderingObjects := OrderedCollection new.
]

{ #category : #accessing }
WDRenderingSceneState >> lights [

	^ lights
]

{ #category : #accessing }
WDRenderingSceneState >> renderingObjects [
	^ renderingObjects
]
