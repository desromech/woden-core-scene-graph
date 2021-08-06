"
A WDMeshBuilderTest is a test class for testing the behavior of WDMeshBuilder
"
Class {
	#name : #WDMeshBuilderTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-RenderableBuilder'
}

{ #category : #tests }
WDMeshBuilderTest >> testCube [
	| builder mesh primitive |
	builder := WDMeshBuilder new.
	
	builder
		addCubeMinX: -1 y: -1 z: -1 maxX: 1 y: 1 z: 1.
		
	self assert: builder vertexCount equals: 4*6.
	self assert: builder positions size equals: 4*6*3.
	self assert: builder colors size equals: 0.
	self assert: builder normals size equals: 4*6*3.
	self assert: builder texcoords0 size equals: 0.
	self assert: builder indices size equals: 6*6.
	
	mesh := builder mesh.
	self assert: mesh primitives size equals: 1.
	primitive := mesh primitives first.

	self assert: primitive vertexBinding vertexCount equals: 4*6.
	
	self assert: primitive topology isTriangles.
	self assert: primitive indices count equals: 6*6.
	self assert: primitive boundingBox equals: (AABox min: (Vector3 x: -1 y: -1 z: -1) max: (Vector3 x: 1 y: 1 z: 1)).
	self assert: mesh boundingBox equals: (AABox min: (Vector3 x: -1 y: -1 z: -1) max: (Vector3 x: 1 y: 1 z: 1)).
]

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
		
		addTriangleI0: 0 i1: 1 i2: 2.
		
	self assert: builder vertexCount equals: 3.
	self assert: builder positions size equals: 9.
	self assert: builder colors size equals: 0.
	self assert: builder normals size equals: 0.
	self assert: builder texcoords0 size equals: 0.
	
	mesh := builder mesh.
	self assert: mesh primitives size equals: 1.
	primitive := mesh primitives first.

	self assert: primitive vertexBinding vertexCount equals: 3.
	
	self assert: primitive topology isTriangles.
	self assert: primitive indices count equals: 3.
	self assert: primitive boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
	self assert: mesh boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
]

{ #category : #tests }
WDMeshBuilderTest >> testTriangle2 [
	| builder mesh primitive |
	builder := WDMeshBuilder new.
	
	builder
		beginTriangles;
		addCr: 1 g: 0 b: 0 a: 1;
		addPx: 0 y: 0 z: 0;
		
		addCr: 0 g: 1 b: 0 a: 1;
		addPx: 2 y: 0 z: 0;

		addCr: 0 g: 0 b: 1 a: 1;
		addPx: 1 y: 1 z: 0;
		
		addTriangleI0: 0 i1: 1 i2: 2.
		
	self assert: builder vertexCount equals: 3.
	self assert: builder positions size equals: 9.
	self assert: builder colors size equals: 12.
	self assert: builder normals size equals: 0.
	self assert: builder texcoords0 size equals: 0.
	
	mesh := builder mesh.
	self assert: mesh primitives size equals: 1.
	primitive := mesh primitives first.

	self assert: primitive vertexBinding vertexCount equals: 3.
	
	self assert: primitive topology isTriangles.
	self assert: primitive indices count equals: 3.
	self assert: primitive boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
	self assert: mesh boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
]

{ #category : #tests }
WDMeshBuilderTest >> testTriangle3 [
	| builder mesh primitive |
	builder := WDMeshBuilder new.
	
	builder
		beginTriangles;
		addCr: 1 g: 0 b: 0 a: 1;
		addNx: 0 y: 0 z: -1;
		addT0u: 0 v: 0;
		addPx: 0 y: 0 z: 0;
		
		addCr: 0 g: 1 b: 0 a: 1;
		addNx: 0 y: 0 z: -1;
		addT0u: 1 v: 0;
		addPx: 2 y: 0 z: 0;

		addCr: 0 g: 0 b: 1 a: 1;
		addNx: 0 y: 0 z: -1;
		addT0u: 0.5 v: 1;
		addPx: 1 y: 1 z: 0;
		
		addTriangleI0: 0 i1: 1 i2: 2.
		
	self assert: builder vertexCount equals: 3.
	self assert: builder positions size equals: 9.
	self assert: builder colors size equals: 12.
	self assert: builder normals size equals: 9.
	self assert: builder texcoords0 size equals: 6.
	self assert: builder texcoords1 size equals: 0.
	
	mesh := builder mesh.
	self assert: mesh primitives size equals: 1.
	primitive := mesh primitives first.

	self assert: primitive vertexBinding vertexCount equals: 3.
	
	self assert: primitive topology isTriangles.
	self assert: primitive indices count equals: 3.
	self assert: primitive boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
	self assert: mesh boundingBox equals: (AABox min: (Vector3 x: 0 y: 0 z: 0) max: (Vector3 x: 2 y: 1 z: 0)).
]
