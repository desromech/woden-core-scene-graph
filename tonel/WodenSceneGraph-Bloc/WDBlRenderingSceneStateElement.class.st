Class {
	#name : #WDBlRenderingSceneStateElement,
	#superclass : #WDBlAbstractRenderingSceneStateElement,
	#instVars : [
		'renderingSceneState'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #accessing }
WDBlRenderingSceneStateElement >> renderingSceneState1 [

	^ renderingSceneState
]

{ #category : #accessing }
WDBlRenderingSceneStateElement >> renderingSceneState: anObject [

	renderingSceneState := anObject
]
