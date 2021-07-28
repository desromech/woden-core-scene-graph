"
I represent a specific primitive topology.
"
Class {
	#name : #WDPrimitiveTopology,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #converting }
WDPrimitiveTopology class >> asPrimitiveTopology [
	self assert: self isAbstract not.
	^ self uniqueInstance
]

{ #category : #testing }
WDPrimitiveTopology class >> isAbstract [
	^ self == WDPrimitiveTopology
]

{ #category : #accessing }
WDPrimitiveTopology class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]

{ #category : #converting }
WDPrimitiveTopology >> asPrimitiveTopology [
	self
]

{ #category : #testing }
WDPrimitiveTopology >> isLineStrip [
	^ false
]

{ #category : #testing }
WDPrimitiveTopology >> isLines [
	^ false
]

{ #category : #testing }
WDPrimitiveTopology >> isPoints [
	^ false
]

{ #category : #testing }
WDPrimitiveTopology >> isTriangleFan [
	^ false
]

{ #category : #testing }
WDPrimitiveTopology >> isTriangleStrip [
	^ false
]

{ #category : #testing }
WDPrimitiveTopology >> isTriangles [
	^ false
]
