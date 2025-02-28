"
I am a bloc background which uses a Woden Color buffer form for its image backing store.
"
Class {
	#name : 'WDBlWodenColorBufferImageBackground',
	#superclass : 'BlBackground',
	#instVars : [
		'renderingSceneStateModel',
		'frameBuffer',
		'colorBuffer'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'comparing' }
WDBlWodenColorBufferImageBackground >> = anotherObject [

	self == anotherObject ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class) ifFalse: [ ^ false ].

	^ anotherObject renderingSceneStateModel == self renderingSceneStateModel
]

{ #category : 'rendering' }
WDBlWodenColorBufferImageBackground >> aeApplyTo: aeCanvas [
	self ensureRenderedSurfaceIsUpdated.
	colorBuffer data ifNotNil: [ 
		aeCanvas setBackgroundWithSurface: colorBuffer data alpha: self opacity
	]
]

{ #category : 'updating' }
WDBlWodenColorBufferImageBackground >> ensureRenderedSurfaceIsUpdated [
	frameBuffer ifNil: [ ^ self ].
	
	(colorBuffer data isNil or: [colorBuffer data isNull]) ifTrue: [ 
		colorBuffer data: (AeCairoImageSurface extent: colorBuffer width @ colorBuffer height format: AeCairoSurfaceFormat argb32)
	].
	
	renderingSceneStateModel renderingSceneState ifNotNil: [ :renderingSceneState |
		WDSceneRenderer current renderSceneState: renderingSceneState intoFramebuffer: frameBuffer.
	].
	
]

{ #category : 'testing' }
WDBlWodenColorBufferImageBackground >> isTransparent [
	^ (self opacity closeTo: 0)
]

{ #category : 'geometry' }
WDBlWodenColorBufferImageBackground >> matchExtent: anExtent [
	| minimalExtent |
	minimalExtent := anExtent ceiling max: 1@1.
]

{ #category : 'accessing' }
WDBlWodenColorBufferImageBackground >> renderingSceneStateModel [

	^ renderingSceneStateModel
]

{ #category : 'accessing' }
WDBlWodenColorBufferImageBackground >> renderingSceneStateModel: anObject [

	renderingSceneStateModel := anObject
]
