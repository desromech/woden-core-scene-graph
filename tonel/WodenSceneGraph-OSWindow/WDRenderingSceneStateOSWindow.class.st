"
I am an OSWindow that can be used for displaying a rendering scene state.
"
Class {
	#name : #WDRenderingSceneStateOSWindow,
	#superclass : #WDAbstractRenderingSceneStateOSWindow,
	#instVars : [
		'renderingSceneState'
	],
	#category : #'WodenSceneGraph-OSWindow'
}

{ #category : #accessing }
WDRenderingSceneStateOSWindow >> renderingSceneState [

	^ renderingSceneState
]

{ #category : #accessing }
WDRenderingSceneStateOSWindow >> renderingSceneState: anObject [

	renderingSceneState := anObject
]
