"
I am a video bloc element.
"
Class {
	#name : 'WDBlVideoElement',
	#superclass : 'BlElement',
	#instVars : [
		'context',
		'container',
		'frameExtent',
		'lastFrameFetchTime',
		'nextFrameFetchTime',
		'frameDurationMicroseconds'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'as yet unclassified' }
WDBlVideoElement >> fetchFrame [
	container fetchAndDecodeNextVideoFrame.
	"container readRGBA32ConvertedFrame: frameExtent x * 4 buffer: playbackForm bits. "

	lastFrameFetchTime := Time microsecondClockValue.
	nextFrameFetchTime := lastFrameFetchTime + frameDurationMicroseconds

]

{ #category : 'as yet unclassified' }
WDBlVideoElement >> fetchFrameIntoCairoSurface: cairoImageSurface [
	container fetchAndDecodeNextVideoFrame.
	cairoImageSurface flush.
	container readRGBA32ConvertedFrame: cairoImageSurface stride buffer: cairoImageSurface data. 

	lastFrameFetchTime := Time microsecondClockValue.
	nextFrameFetchTime := lastFrameFetchTime + frameDurationMicroseconds

]

{ #category : 'accessing' }
WDBlVideoElement >> frameExtent [
	^ frameExtent
]

{ #category : 'initialization' }
WDBlVideoElement >> initialize [
	super initialize.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent
	].
	self background: (WDBlVideoPlaybackImageBackground new videoController: self; yourself).
]

{ #category : 'as yet unclassified' }
WDBlVideoElement >> openWithUrl: videoStreamUrl [
	| platform contextOpenInfo url videoFrameRate |
	platform := AVIDEO platforms first.
	contextOpenInfo := AVIDEOContextOpenInfo new.
	context := platform openContext: contextOpenInfo.
	
	url := videoStreamUrl.
	container := context openContainerWithURL: videoStreamUrl.

	frameExtent := container getVideoStreamWidth @ container getVideoStreamHeight.
	
	videoFrameRate := container getVideoStreamFrameRate.
	frameDurationMicroseconds := 1000000 / videoFrameRate.
	self fetchFrame.
	^ self

]
