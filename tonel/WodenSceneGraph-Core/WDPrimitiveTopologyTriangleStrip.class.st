"
I represent the topology of primitives which represent a connected set of triangles.

I have a direct correspondence to GL_TRIANGLE_STRIP in OpenGL.
"
Class {
	#name : 'WDPrimitiveTopologyTriangleStrip',
	#superclass : 'WDPrimitiveTopology',
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'testing' }
WDPrimitiveTopologyTriangleStrip >> isTriangleStrip [
	^ true
]
