"
I represent the topology of primitives which represent a connected set of triangles emanating from a shared central vertex.

I have a direct correspondence to GL_TRIANGLE_FAN in OpenGL.
"
Class {
	#name : #WDPrimitiveTopologyTriangleFan,
	#superclass : #WDPrimitiveTopology,
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #testing }
WDPrimitiveTopologyTriangleFan >> isTriangleFan [
	^ true
]
