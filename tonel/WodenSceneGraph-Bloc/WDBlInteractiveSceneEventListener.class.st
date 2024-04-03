"
I am an event listener for the Woden block interactive scene element.
"
Class {
	#name : #WDBlInteractiveSceneEventListener,
	#superclass : #BlEventListener,
	#instVars : [
		'startPosition',
		'sceneElement',
		'delta',
		'currentPosition'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #'dnd handlers' }
WDBlInteractiveSceneEventListener >> dragEvent: anEvent [
	delta := anEvent position - currentPosition.
	currentPosition := anEvent position.
	sceneElement dragCameraDelta: delta withEvent: anEvent
]

{ #category : #'dnd handlers' }
WDBlInteractiveSceneEventListener >> dragStartEvent: anEvent [
	anEvent consumed: true.
	currentPosition := anEvent position.
]

{ #category : #'mouse handlers' }
WDBlInteractiveSceneEventListener >> mouseWheelEvent: anEvent [
	anEvent consumed: true.
	sceneElement scrollCamera: anEvent vector
]

{ #category : #'api - hooks' }
WDBlInteractiveSceneEventListener >> onInstalledIn: anElement [
	sceneElement := anElement
]
