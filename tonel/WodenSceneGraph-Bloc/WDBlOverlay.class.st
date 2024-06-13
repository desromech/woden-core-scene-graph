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

{ #category : 'as yet unclassified' }
WDBlOverlay class >> withExtent: anExtent [
	^ self new makeSpaceWithExtent: anExtent; yourself
]

{ #category : 'drawing' }
WDBlOverlay >> buildSceneGraphWith: builder [
	| texture extent origin |
	texture := self space host texture.
	texture ifNil: [ ^ builder null ].
	
	extent := texture width @ texture height.
	origin := (builder clippingBounds extent / 2) - (extent / 2).
	
	^ builder texturedRectangle: (origin extent: extent) wodenTexture: texture
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
