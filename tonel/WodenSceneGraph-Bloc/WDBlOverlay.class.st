"
I am a Woden overlay that uses Bloc.
"
Class {
	#name : 'WDBlOverlay',
	#superclass : 'WDOverlay',
	#instVars : [
		'space'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'drawing' }
WDBlOverlay >> buildSceneGraphWith: builder [
	| texture |
	texture := self space host texture.
	texture ifNil: [ ^ builder null ].
	
	Transcript show: texture extent; cr.
	^ builder null
]

{ #category : 'as yet unclassified' }
WDBlOverlay >> makeSpaceWithExtent: extent [
	space := BlSpace new
		extent: extent;
		host: (WDBlTextureHost extent: extent);
		yourself
	
	
]

{ #category : 'accessing' }
WDBlOverlay >> space [

	^ space
]

{ #category : 'accessing' }
WDBlOverlay >> space: anObject [

	space := anObject
]
