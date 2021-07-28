"
I represent the topology of primitives which represent a set of triangles which are specified by three vertices.

I have a direct correspondence to GL_TRIANGLES in OpenGL.
"
Class {
	#name : #WDPrimitiveTopologyTriangles,
	#superclass : #WDPrimitiveTopology,
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #testing }
WDPrimitiveTopologyTriangles >> isTriangles [
	^ true
]
