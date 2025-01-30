Class {
	#name : 'WDBlVideoPlaybackImageBackground',
	#superclass : 'BlBackground',
	#instVars : [
		'videoController',
		'videoOutput',
		'videoFrameExtent'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'geometry' }
WDBlVideoPlaybackImageBackground >> = anotherObject [

	self == anotherObject ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class) ifFalse: [ ^ false ].

	^ anotherObject videoController == self videoController
]

{ #category : 'geometry' }
WDBlVideoPlaybackImageBackground >> aeApplyTo: aeCanvas [
	self ensureRenderedSurfaceIsUpdated.
	videoOutput ifNotNil: [ 
		aeCanvas setBackgroundWithSurface: videoOutput alpha: self opacity
	]
]

{ #category : 'geometry' }
WDBlVideoPlaybackImageBackground >> ensureRenderedSurfaceIsUpdated [
	videoOutput isNil ifTrue: [
		videoFrameExtent := videoController frameExtent.
		videoOutput := AeCairoImageSurface extent: videoFrameExtent format: AeCairoSurfaceFormat argb32.
	].
	
	videoController ifNotNil: [
		videoController fetchFrameIntoCairoSurface: videoOutput
	].
]

{ #category : 'geometry' }
WDBlVideoPlaybackImageBackground >> isTransparent [
	^ (self opacity closeTo: 0)
]

{ #category : 'geometry' }
WDBlVideoPlaybackImageBackground >> matchExtent: anExtent [
	| minimalExtent |
	minimalExtent := anExtent ceiling max: 1@1.
]

{ #category : 'accessing' }
WDBlVideoPlaybackImageBackground >> videoController [

	^ videoController
]

{ #category : 'accessing' }
WDBlVideoPlaybackImageBackground >> videoController: anObject [

	videoController := anObject
]
