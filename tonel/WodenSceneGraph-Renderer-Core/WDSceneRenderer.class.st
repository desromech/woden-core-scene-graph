"
I am the interface for a scene renderer.
"
Class {
	#name : #WDSceneRenderer,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Renderer-Core-WodenSceneGraph-Renderer-Core'
}

{ #category : #testing }
WDSceneRenderer class >> isAbstract [
	^ self == WDSceneRenderer
]

{ #category : #testing }
WDSceneRenderer class >> isAvailable [
	^ false
]

{ #category : #rendering }
WDSceneRenderer >> renderSceneState: renderingSceneState intoFramebuffer: framebuffer [
	self subclassResponsibility
]
