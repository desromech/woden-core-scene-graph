"
I am a generic event handler that is used for displaying a woden rendering scene state in an oswindow.
"
Class {
	#name : #WDAbstractRenderingSceneStateOSWindowEventHandler,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'window'
	],
	#category : #'WodenSceneGraph-OSWindow'
}

{ #category : #visiting }
WDAbstractRenderingSceneStateOSWindowEventHandler >> visitWindowCloseEvent: anEvent [
	window ifNotNil: [ window closeRequest ].
	anEvent suppressDefaultAction
]

{ #category : #visiting }
WDAbstractRenderingSceneStateOSWindowEventHandler >> visitWindowExposeEvent: anEvent [
	window ifNotNil: [ window exposed ].
	anEvent suppressDefaultAction
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindowEventHandler >> window [

	^ window
]

{ #category : #accessing }
WDAbstractRenderingSceneStateOSWindowEventHandler >> window: anObject [

	window := anObject
]
