"
I represent the topology of primitives which are single line segments that are specified by pairs of vertices.

I have a direct correspondence to GL_LINES in OpenGL.
"
Class {
	#name : #WDPrimitiveTopologyLines,
	#superclass : #WDPrimitiveTopology,
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #testing }
WDPrimitiveTopologyLines >> isLines [
	^ true
]
