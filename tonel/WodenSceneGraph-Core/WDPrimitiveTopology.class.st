"
I represent a specific primitive topology.
"
Class {
	#name : 'WDPrimitiveTopology',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'converting' }
WDPrimitiveTopology class >> asPrimitiveTopology [
	self assert: self isAbstract not.
	^ self uniqueInstance
]

{ #category : 'testing' }
WDPrimitiveTopology class >> isAbstract [
	^ self == WDPrimitiveTopology
]

{ #category : 'converting' }
WDPrimitiveTopology >> asPrimitiveTopology [
	self
]

{ #category : 'testing' }
WDPrimitiveTopology >> isLineStrip [
	^ false
]

{ #category : 'testing' }
WDPrimitiveTopology >> isLines [
	^ false
]

{ #category : 'testing' }
WDPrimitiveTopology >> isPoints [
	^ false
]

{ #category : 'testing' }
WDPrimitiveTopology >> isTriangleStrip [
	^ false
]

{ #category : 'testing' }
WDPrimitiveTopology >> isTriangles [
	^ false
]

{ #category : 'as yet unclassified' }
WDPrimitiveTopology >> triangleIndicesWithBase: baseIndex count: indexCount do: aBlock [
	"Iterate through the triangle indices that corresponds to this topology."
]
