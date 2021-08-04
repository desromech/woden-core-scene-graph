"
A WDMetallicRoughnessMaterialTest is a test class for testing the behavior of WDMetallicRoughnessMaterial
"
Class {
	#name : #WDMetallicRoughnessMaterialTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-Material'
}

{ #category : #tests }
WDMetallicRoughnessMaterialTest >> testNew [
	| material |
	material := WDMetallicRoughnessMaterial new.
	self deny: material doubleSided.
	self assert: material alphaCutoff equals: 0.5.
	self assert: material alphaMode equals: #OPAQUE.
	self assert: material isOpaque.
	self deny: material hasAlphaMasking.
	self deny: material hasAlphaBlending.
	
	self assert: material baseColorFactor equals: Vector4 ones.
	self assert: material emissiveFactor equals: Vector3 zeros.
	self assert: material metallicFactor equals: 1.0.
	self assert: material roughnessFactor equals: 1.0.
	self assert: material occlusionFactor equals: 1.0.


]
