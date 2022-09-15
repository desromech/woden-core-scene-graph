Class {
	#name : #WDRenderingSceneShadowMapSet,
	#superclass : #Object,
	#instVars : [
		'lightSource',
		'cameraStates',
		'renderingScenes',
		'renderingSceneComputationBlock'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> cameraStates [

	^ cameraStates
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> cameraStates: anObject [

	cameraStates := anObject
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> lightSource [

	^ lightSource
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> lightSource: anObject [

	lightSource := anObject
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> renderingSceneComputationBlock [

	^ renderingSceneComputationBlock
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> renderingSceneComputationBlock: anObject [

	renderingSceneComputationBlock := anObject
]

{ #category : #accessing }
WDRenderingSceneShadowMapSet >> renderingScenes [
	^ renderingScenes ifNil: [ renderingScenes := cameraStates collect: [ :cameraState |
		renderingSceneComputationBlock value: cameraState
		] 
	]

]
