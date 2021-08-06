"
I am a morph that displays a single Woden scene.
"
Class {
	#name : #WDSceneMorph,
	#superclass : #WDAbstractRenderingSceneStateMorph,
	#instVars : [
		'scene',
		'camera'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #accessing }
WDSceneMorph >> camera [

	^ camera
]

{ #category : #accessing }
WDSceneMorph >> camera: anObject [

	camera := anObject
]

{ #category : #accessing }
WDSceneMorph >> scene [

	^ scene
]

{ #category : #accessing }
WDSceneMorph >> scene: aWDScene [
	scene := aWDScene.
	self changed
]
