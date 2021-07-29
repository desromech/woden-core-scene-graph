"
A WDMeshBuilderTest is a test class for testing the behavior of WDMeshBuilder
"
Class {
	#name : #WDMeshBuilderTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests'
}

{ #category : #tests }
WDMeshBuilderTest >> testEmpty [
	| builder mesh |
	builder := WDMeshBuilder new.
	mesh := builder mesh.
	self assert: mesh primitives isEmpty.
]

{ #category : #tests }
WDMeshBuilderTest >> testTriangle [
	| builder mesh primitive |
	builder := WDMeshBuilder new.
	
	builder
		beginTriangles;
		addPx: 0 y: 0 z: 0;
		addPx: 2 y: 0 z: 0;
		addPx: 1 y: 1 z: 0;
		
		addTriangleI0: 0 i1: 1 i2: 3.
		
	self assert: builder vertexCount equals: 3.
	self assert: builder positions size equals: 9.
	self assert: builder colors size equals: 0.
	self assert: builder normals size equals: 0.
	self assert: builder texcoords size equals: 0.
	
	mesh := builder mesh.
	self assert: mesh primitives size equals: 1.
	primitive := mesh primitives first.

	self assert: primitive vertexBinding vertexCount equals: 3.
	
	self assert: primitive topology isTriangles.
	self assert: primitive indices count equals: 3.
]
