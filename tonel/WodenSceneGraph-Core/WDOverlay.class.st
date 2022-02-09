"
I am a generic 2D overlay whose content is drawn through the Form Scene Graph.
"
Class {
	#name : #WDOverlay,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-Overlay'
}

{ #category : #drawing }
WDOverlay >> buildFullSceneGraphWith: builder [
	^ self buildSceneGraphWith: builder
]

{ #category : #drawing }
WDOverlay >> buildSceneGraphWith: builder [
	^ builder null
]
