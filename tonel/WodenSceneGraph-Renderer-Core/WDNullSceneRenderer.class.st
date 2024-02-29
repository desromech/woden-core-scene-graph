"
I am a scene renderer that does nothing.
"
Class {
	#name : #WDNullSceneRenderer,
	#superclass : #WDSceneRenderer,
	#category : #'WodenSceneGraph-Renderer-Core'
}

{ #category : #testing }
WDNullSceneRenderer >> isNullSceneRenderer [
	^ true
]

{ #category : #rendering }
WDNullSceneRenderer >> renderSceneState: renderingSceneState overlay: overlaySceneGraph intoFramebuffer: framebuffer [
	"Nothing is required here."
]
