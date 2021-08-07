"
I am a Spec2 morphic based adapter for presenting for a Woden Scene.
"
Class {
	#name : #WDSpSceneMorphicAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#category : #'WodenSceneGraph-Spec'
}

{ #category : #accessing }
WDSpSceneMorphicAdapter class >> adaptingName [
	^ #WodenSceneAdapter
]

{ #category : #factory }
WDSpSceneMorphicAdapter >> buildWidget [
	| newWidget |

	newWidget := self sceneMorphClass new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		scene: self presenter scene;
		camera: self presenter camera;
		yourself.

	self presenter whenSceneChangedDo: [ :newScene | newWidget scene: newScene ].
	self presenter whenCameraChangedDo: [ :newCamera | newWidget camera: newCamera ].

	^ newWidget
]

{ #category : #hooks }
WDSpSceneMorphicAdapter >> sceneMorphClass [
	^ WDSceneMorph
]
