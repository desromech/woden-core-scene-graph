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
