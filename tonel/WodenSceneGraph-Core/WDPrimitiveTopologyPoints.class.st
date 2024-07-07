"
I represent the topology of primitives which are single points.

I have a direct correspondence to GL_POINTS in OpenGL.
"
Class {
	#name : 'WDPrimitiveTopologyPoints',
	#superclass : 'WDPrimitiveTopology',
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'testing' }
WDPrimitiveTopologyPoints >> isPoints [
	^ true
]
