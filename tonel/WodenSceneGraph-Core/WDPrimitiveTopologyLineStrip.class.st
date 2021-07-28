"
I represent the topology of primitives which represent connected line segment.

I have a direct correspondence to GL_LINE_STRIP in OpenGL.
"
Class {
	#name : #WDPrimitiveTopologyLineStrip,
	#superclass : #WDPrimitiveTopology,
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #testing }
WDPrimitiveTopologyLineStrip >> isLineStrip [
	^ true
]
