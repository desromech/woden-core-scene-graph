"
A WDRenderingSceneStateTest is a test class for testing the behavior of WDRenderingSceneState
"
Class {
	#name : #WDRenderingSceneCameraLayerStateTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-RenderingState'
}

{ #category : #tests }
WDRenderingSceneCameraLayerStateTest >> makeRenderable [
	^ WDMeshBuilder new
	beginTriangles;
	addCr: 1 g: 0 b: 0 a: 1;
	addPx: -1 y: -1 z: 0;

	addCr: 0 g: 1 b: 0 a: 1;
	addPx: 1 y: -1 z: 0;

	addCr: 0 g: 0 b: 1 a: 1;
	addPx: 0 y: 1 z: 0;
	addTriangleI0: 0 i1: 1 i2: 2;
	mesh.
]

{ #category : #tests }
WDRenderingSceneCameraLayerStateTest >> testAddRenderable [
	| renderable objectState renderingScene renderingObject |
	renderable := self makeRenderable.
	objectState := WDRenderingObjectState new.

	renderingScene := WDRenderingSceneCameraLayer new.
	renderingScene opaqueRenderingObjects isEmpty.
	renderingScene translucentRenderingObjects isEmpty.
	
	renderingScene addRenderable: renderable withObjectState: objectState.
	
	self assert: renderingScene opaqueRenderingObjects size equals: 1.
	self assert: renderingScene translucentRenderingObjects isEmpty.
	renderingObject := renderingScene opaqueRenderingObjects first.
	
	self assert: renderingObject priority equals: WDRenderPriority default.
	self assert: renderingObject renderable equals: renderable primitives first.
]
