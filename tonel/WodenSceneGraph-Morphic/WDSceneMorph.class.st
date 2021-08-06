"
I am a morph that displays a single Woden scene.
"
Class {
	#name : #WDSceneMorph,
	#superclass : #WDAbstractRenderingSceneMorph,
	#instVars : [
		'scene'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #accessing }
WDSceneMorph >> scene [

	^ scene
]

{ #category : #accessing }
WDSceneMorph >> scene: aWDScene [
	scene := aWDScene.
	self changed
]
