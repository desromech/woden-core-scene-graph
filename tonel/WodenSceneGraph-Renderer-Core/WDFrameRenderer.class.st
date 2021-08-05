"
I am the double-dispatch based interface for a frame specific renderer.
"
Class {
	#name : #WDFrameRenderer,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Renderer-Core-WodenSceneGraph-Renderer-Core'
}

{ #category : #rendering }
WDFrameRenderer >> emitRenderingCommandsForMeshPrimitive: meshPrimitive [
	self subclassResponsibility
]
