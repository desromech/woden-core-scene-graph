"
I encapsulate the scene state for rendering multiple camera layers.
"
Class {
	#name : #WDRenderingScene,
	#superclass : #Object,
	#instVars : [
		'mainCameraState',
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

{ #category : #accessing }
WDRenderingScene >> hasReverseDepth [
	^ cameraLayers first hasReverseDepth
]

{ #category : #initialization }
WDRenderingScene >> initialize [
	super initialize.
	cameraLayers := #().
]

{ #category : #accessing }
WDRenderingScene >> mainCameraState [

	^ mainCameraState
]

{ #category : #accessing }
WDRenderingScene >> mainCameraState: anObject [

	mainCameraState := anObject
]

{ #category : #accessing }
WDRenderingScene >> sampleCount [
	^ cameraLayers first sampleCount
]
