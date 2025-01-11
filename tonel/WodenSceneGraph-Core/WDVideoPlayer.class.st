"
I am a video player whose output is sent to form.
"
Class {
	#name : 'WDVideoPlayer',
	#superclass : 'WDTextureStreamDataSource',
	#instVars : [
		'url',
		'playbackTexture',
		'frameExtent',
		'platform',
		'contextOpenInfo',
		'context',
		'container',
		'playbackForm',
		'lastFrameFetchTime',
		'nextFrameFetchTime',
		'videoFrameRate',
		'frameDurationMicroseconds'
	],
	#category : 'WodenSceneGraph-Core-Async',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Async'
}

{ #category : 'as yet unclassified' }
WDVideoPlayer >> fetchFrame [
	container fetchAndDecodeNextVideoFrame.
	playbackForm unhibernate.
	container readRGBA32ConvertedFrame: frameExtent x * 4 buffer: playbackForm bits. 
	playbackTexture changed.
	lastFrameFetchTime := Time microsecondClockValue.
	nextFrameFetchTime := lastFrameFetchTime + frameDurationMicroseconds

]

{ #category : 'as yet unclassified' }
WDVideoPlayer >> openWithUrl: videoStreamUrl [
	platform := AVIDEO platforms first.
	contextOpenInfo := AVIDEOContextOpenInfo new.
	context := platform openContext: contextOpenInfo.
	
	url := videoStreamUrl.
	container := context openContainerWithURL: videoStreamUrl.

	frameExtent := container getVideoStreamWidth @ container getVideoStreamHeight.
	playbackForm := Form extent: frameExtent depth: 32.
	playbackTexture := WDTexture forColorForm: playbackForm.
	playbackTexture streamDataSource: self.
	videoFrameRate := container getVideoStreamFrameRate.
	frameDurationMicroseconds := 1000000 / videoFrameRate.
	self fetchFrame.
	^ self

]

{ #category : 'accessing' }
WDVideoPlayer >> playbackForm [

	^ playbackForm
]

{ #category : 'accessing' }
WDVideoPlayer >> playbackForm: anObject [

	playbackForm := anObject
]

{ #category : 'accessing' }
WDVideoPlayer >> playbackTexture [

	^ playbackTexture
]

{ #category : 'accessing' }
WDVideoPlayer >> playbackTexture: anObject [

	playbackTexture := anObject
]

{ #category : 'as yet unclassified' }
WDVideoPlayer >> updateTextureData [
	| currentFrameFetchTime |
	currentFrameFetchTime := Time microsecondClockValue..
	currentFrameFetchTime >= nextFrameFetchTime ifTrue: [
		self fetchFrame 
	]
]

{ #category : 'accessing' }
WDVideoPlayer >> videoFrameRate [

	^ videoFrameRate
]
