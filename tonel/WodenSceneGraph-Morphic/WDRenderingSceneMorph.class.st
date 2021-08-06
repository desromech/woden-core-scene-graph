"
I am a morph that displays a single Woden rendering scene state which is specified in a explicit way.
"
Class {
	#name : #WDRenderingSceneMorph,
	#superclass : #WDAbstractRenderingSceneMorph,
	#instVars : [
		'renderingSceneState'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #accessing }
WDRenderingSceneMorph >> renderingSceneState [

	^ renderingSceneState
]

{ #category : #accessing }
WDRenderingSceneMorph >> renderingSceneState: aWDRenderingSceneState [
	renderingSceneState := aWDRenderingSceneState.
	self changed
]
