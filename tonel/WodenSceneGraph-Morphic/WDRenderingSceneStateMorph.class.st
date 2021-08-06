"
I am a morph that displays a single Woden rendering scene state which is specified in a explicit way.
"
Class {
	#name : #WDRenderingSceneStateMorph,
	#superclass : #WDAbstractRenderingSceneStateMorph,
	#instVars : [
		'renderingSceneState'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #accessing }
WDRenderingSceneStateMorph >> renderingSceneState [

	^ renderingSceneState
]

{ #category : #accessing }
WDRenderingSceneStateMorph >> renderingSceneState: aWDRenderingSceneState [
	renderingSceneState := aWDRenderingSceneState.
	self changed
]
