"
I am a Spec2 morphic based adapter for presenting for a Woden Rendering Scene State.
"
Class {
	#name : #WDSpRenderingSceneStateMorphicAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#category : #'WodenSceneGraph-Spec'
}

{ #category : #accessing }
WDSpRenderingSceneStateMorphicAdapter class >> adaptingName [
	^ #WodenRenderingSceneStateAdapter
]

{ #category : #factory }
WDSpRenderingSceneStateMorphicAdapter >> buildWidget [
	| newWidget |

	newWidget := WDRenderingSceneStateMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		renderingSceneState: self presenter renderingSceneState;
		yourself.

	self presenter whenRenderingSceneStateChangedDo: [ :newRenderingSceneState | newWidget renderingSceneState: newRenderingSceneState ].

	^ newWidget
]
