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
		overlay: self presenter overlay;
		yourself.

	self presenter whenSceneChangedDo: [ :newScene | newWidget scene: newScene ].
	self presenter whenCameraChangedDo: [ :newCamera | newWidget camera: newCamera ].
	self presenter whenOverlayChangedDo: [ :newOverlay | newWidget overlay: newOverlay ].

	^ newWidget
]

{ #category : #hooks }
WDSpSceneMorphicAdapter >> sceneMorphClass [
	^ WDSceneMorph
]
