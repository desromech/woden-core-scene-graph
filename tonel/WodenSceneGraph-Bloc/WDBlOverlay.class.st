"
I am a Woden overlay that uses Bloc.
"
Class {
	#name : 'WDBlOverlay',
	#superclass : 'WDOverlay',
	#instVars : [
		'space',
		'drawingPosition',
		'centeringFraction'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'constructing' }
WDBlOverlay class >> withExtent: anExtent [
	^ self new makeSpaceWithExtent: anExtent; yourself
]

{ #category : 'constructing' }
WDBlOverlay class >> withExtent: anExtent buildSpace: aBlock [
	| overlay |
	overlay := self withExtent: anExtent.
	aBlock value: overlay space.
	overlay space show.
	^ overlay
]

{ #category : 'drawing' }
WDBlOverlay >> buildSceneGraphWith: builder [
	| texture extent |
	texture := self space host texture.
	texture ifNil: [ ^ builder null ].
	
	extent := texture width @ texture height.
	drawingPosition := ((builder clippingBounds extent - extent) * self centeringFraction) rounded.
	
	^ builder texturedRectangle: (drawingPosition extent: extent) wodenTexture: texture
]

{ #category : 'alignment' }
WDBlOverlay >> centered [
	self centeringFraction: (1/2)@(1/2)
]

{ #category : 'accessing' }
WDBlOverlay >> centeringFraction [

	^ centeringFraction
]

{ #category : 'accessing' }
WDBlOverlay >> centeringFraction: anObject [

	centeringFraction := anObject
]

{ #category : 'initialization' }
WDBlOverlay >> initialize [
	super initialize.
	drawingPosition := 0@0.
	centeringFraction := (1/2)@(1/2).
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
