"
I represent the topology of primitives which represent a set of triangles which are specified by three vertices.

I have a direct correspondence to GL_TRIANGLES in OpenGL.
"
Class {
	#name : 'WDPrimitiveTopologyTriangles',
	#superclass : 'WDPrimitiveTopology',
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'testing' }
WDPrimitiveTopologyTriangles >> isTriangles [
	^ true
]

{ #category : 'as yet unclassified' }
WDPrimitiveTopologyTriangles >> triangleIndicesWithBase: baseIndex count: indexCount do: aBlock [
	"Iterate through the triangle indices that corresponds to this topology."
	| triangleCount currentIndex |
	triangleCount := indexCount  // 3.
	currentIndex := baseIndex.
	1 to: triangleCount do: [ :i |
		aBlock value: currentIndex value: currentIndex + 1 value: currentIndex + 2.
		currentIndex := currentIndex + 3
	]
]
