"
A WDPrimitiveTopologyTest is a test class for testing the behavior of WDPrimitiveTopology
"
Class {
	#name : #WDPrimitiveTopologyTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-Renderable'
}

{ #category : #tests }
WDPrimitiveTopologyTest >> testTestingMethods [
	| base |
	base := WDPrimitiveTopology basicNew.
	self deny: base isPoints.
	self deny: base isLines.
	self deny: base isLineStrip.
	self deny: base isTriangles.
	self deny: base isTriangleStrip.
		
	self assert: WDPrimitiveTopologyPoints asPrimitiveTopology isPoints.
	self assert: WDPrimitiveTopologyLines asPrimitiveTopology isLines.
	self assert: WDPrimitiveTopologyLineStrip asPrimitiveTopology isLineStrip.
	self assert: WDPrimitiveTopologyTriangles asPrimitiveTopology isTriangles.
	self assert: WDPrimitiveTopologyTriangleStrip asPrimitiveTopology isTriangleStrip.
]
