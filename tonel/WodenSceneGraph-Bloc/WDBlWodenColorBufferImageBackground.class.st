"
I am a bloc background which uses a Woden Color buffer form for its image backing store.
"
Class {
	#name : #WDBlWodenColorBufferImageBackground,
	#superclass : #BlBackground,
	#instVars : [
		'renderingSceneStateModel',
		'formFrameBuffer',
		'formColorBuffer'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #comparing }
WDBlWodenColorBufferImageBackground >> = anotherObject [

	self == anotherObject ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class) ifFalse: [ ^ false ].

	^ anotherObject renderingSceneStateModel == self renderingSceneStateModel
]

{ #category : #rendering }
WDBlWodenColorBufferImageBackground >> aeApplyTo: aeCanvas [
	self ensureRenderedFormIsUpdated.
	aeCanvas setBackgroundWithForm: (formColorBuffer ifNotNil: [formColorBuffer data]) alpha: self opacity
]

{ #category : #updating }
WDBlWodenColorBufferImageBackground >> ensureRenderedFormIsUpdated [
	formFrameBuffer ifNil: [ ^ self ].
	
	renderingSceneStateModel renderingSceneState ifNotNil: [ :renderingSceneState |
		WDSceneRenderer current renderSceneState: renderingSceneState intoFramebuffer: formFrameBuffer.
	].
	
]

{ #category : #rendering }
WDBlWodenColorBufferImageBackground >> formImage [
	self ensureRenderedFormIsUpdated.
	^ formColorBuffer ifNotNil: [ formColorBuffer data ]
]

{ #category : #accessing }
WDBlWodenColorBufferImageBackground >> image [
	self ensureRenderedFormIsUpdated.
	^ super image
]

{ #category : #testing }
WDBlWodenColorBufferImageBackground >> isTransparent [
	^ (self opacity closeTo: 0)
]

{ #category : #geometry }
WDBlWodenColorBufferImageBackground >> matchExtent: anExtent [
	| minimalExtent |
	minimalExtent := anExtent ceiling max: 1@1.
	(formFrameBuffer isNil or: [ formFrameBuffer extent ~= minimalExtent ]) ifTrue: [
		formColorBuffer := WDTexture forReadedColorBufferWithExtent: minimalExtent.
		formFrameBuffer := WDFramebuffer forColorAttachment: formColorBuffer.
	].
]

{ #category : #accessing }
WDBlWodenColorBufferImageBackground >> renderingSceneStateModel [

	^ renderingSceneStateModel
]

{ #category : #accessing }
WDBlWodenColorBufferImageBackground >> renderingSceneStateModel: anObject [

	renderingSceneStateModel := anObject
]
