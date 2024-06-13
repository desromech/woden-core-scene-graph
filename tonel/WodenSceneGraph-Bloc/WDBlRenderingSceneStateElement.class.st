"
I am Bloc element that can receive a specific woden rendering scene state for displaying.
"
Class {
	#name : 'WDBlRenderingSceneStateElement',
	#superclass : 'WDBlAbstractRenderingSceneStateElement',
	#instVars : [
		'renderingSceneState'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'accessing' }
WDBlRenderingSceneStateElement >> renderingSceneState [

	^ renderingSceneState
]

{ #category : 'accessing' }
WDBlRenderingSceneStateElement >> renderingSceneState: anObject [

	renderingSceneState := anObject
]
