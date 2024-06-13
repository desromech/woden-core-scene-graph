"
I am an event listener for the Woden block interactive scene element.
"
Class {
	#name : 'WDBlInteractiveSceneEventListener',
	#superclass : 'BlEventListener',
	#instVars : [
		'sceneElement'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'dnd handlers' }
WDBlInteractiveSceneEventListener >> dragEvent: anEvent [
	sceneElement dragCameraWithEvent: anEvent
]

{ #category : 'dnd handlers' }
WDBlInteractiveSceneEventListener >> dragStartEvent: anEvent [
	anEvent consumed: true.
]

{ #category : 'mouse handlers' }
WDBlInteractiveSceneEventListener >> mouseWheelEvent: anEvent [
	anEvent consumed: true.
	sceneElement scrollCamera: anEvent vector
]

{ #category : 'api - hooks' }
WDBlInteractiveSceneEventListener >> onInstalledIn: anElement [
	sceneElement := anElement
]
