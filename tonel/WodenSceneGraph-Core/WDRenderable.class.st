"
I am an object that can be rendered on 3D graphics scene.
"
Class {
	#name : #WDRenderable,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #adding }
WDRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	self subclassResponsibility
]

{ #category : #converting }
WDRenderable >> asSceneElement [
	^ self asSceneNode
]

{ #category : #converting }
WDRenderable >> asSceneNode [
	^ WDSceneNode new
		renderables: { self };
		yourself
]

{ #category : #'double dispatch' }
WDRenderable >> emitRenderingCommandsWithRenderer: renderer [
]
