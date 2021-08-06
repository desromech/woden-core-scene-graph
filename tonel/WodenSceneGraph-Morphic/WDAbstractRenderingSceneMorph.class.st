"
I am an abstract morph that connect a Woden RenderingSceneState with the Pharo UI by using the current per-session renderer.
"
Class {
	#name : #WDAbstractRenderingSceneMorph,
	#superclass : #Morph,
	#instVars : [
		'formFrameBuffer',
		'formColorBuffer'
	],
	#category : #'WodenSceneGraph-Morphic'
}

{ #category : #drawing }
WDAbstractRenderingSceneMorph >> drawOn: aCanvas [
	| renderingSceneState |
	renderingSceneState := self renderingSceneState.
	renderingSceneState ifNil: [ ^ super drawOn: aCanvas ].
	self renderRenderingSceneStateIntoFormFramebuffer: renderingSceneState.
	aCanvas drawImage: formColorBuffer data at: self bounds origin.
	
]

{ #category : #drawing }
WDAbstractRenderingSceneMorph >> renderRenderingSceneStateIntoFormFramebuffer: renderingSceneState [
	| drawingExtent |
	drawingExtent := self extent ceiling.
	(formFrameBuffer isNil or: [ formFrameBuffer extent ~= drawingExtent ]) ifTrue: [
		formColorBuffer := WDTexture forReadedColorBufferWithExtent: drawingExtent.
		formFrameBuffer := WDFramebuffer forColorAttachment: formColorBuffer.
	].
	WDSceneRenderer current renderSceneState: renderingSceneState intoFramebuffer: formFrameBuffer.
	
]

{ #category : #accessing }
WDAbstractRenderingSceneMorph >> renderingSceneState [
	^ nil
]
