"
I encapsulate the scene state for rendering multiple camera layers.
"
Class {
	#name : #WDRenderingScene,
	#superclass : #Object,
	#instVars : [
		'cameraLayers'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderingScene >> cameraLayers [

	^ cameraLayers
]

{ #category : #accessing }
WDRenderingScene >> cameraLayers: anObject [

	cameraLayers := anObject
]

{ #category : #initialization }
WDRenderingScene >> initialize [
	super initialize.
	cameraLayers := #().
]
