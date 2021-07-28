"
A WDUnlitMaterialTest is a test class for testing the behavior of WDUnlitMaterial
"
Class {
	#name : #WDUnlitMaterialTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests'
}

{ #category : #tests }
WDUnlitMaterialTest >> testNew [
	| material |
	material := WDUnlitMaterial new.
	self deny: material doubleSided.
	self assert: material alphaCutoff equals: 0.5.
	self assert: material alphaMode equals: #OPAQUE.
	self assert: material isOpaque.
	self deny: material hasAlphaMasking.
	self deny: material hasAlphaBlending.
	
	self assert: material colorFactor equals: Vector4 ones.
]
