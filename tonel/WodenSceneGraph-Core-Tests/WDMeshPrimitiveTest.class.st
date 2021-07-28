"
A WDMeshPrimitiveTest is a test class for testing the behavior of WDMeshPrimitive
"
Class {
	#name : #WDMeshPrimitiveTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests'
}

{ #category : #tests }
WDMeshPrimitiveTest >> testNew [
	| primitive |
	primitive := WDMeshPrimitive new.
	self assert: primitive topology isPoints.
	self assert: primitive material isNil.
	self assert: primitive vertexBinding isNil.
	self assert: primitive indices isNil.
]
