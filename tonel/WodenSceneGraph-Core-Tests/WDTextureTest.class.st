"
A WDTextureTest is a test class for testing the behavior of WDTexture
"
Class {
	#name : #WDTextureTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-Texture'
}

{ #category : #tests }
WDTextureTest >> testComputeMiplevels [
	self assert: (WDTexture computeMiplevelsForExtent: 1@1) equals: 1.
	self assert: (WDTexture computeMiplevelsForExtent: 2@2) equals: 2.
	self assert: (WDTexture computeMiplevelsForExtent: 2@1) equals: 2.
	self assert: (WDTexture computeMiplevelsForExtent: 1@2) equals: 2.
	self assert: (WDTexture computeMiplevelsForExtent: 3@2) equals: 1.
	self assert: (WDTexture computeMiplevelsForExtent: 2@3) equals: 1.
	self assert: (WDTexture computeMiplevelsForExtent: 4@4) equals: 3.
	self assert: (WDTexture computeMiplevelsForExtent: 4@1) equals: 3.
	self assert: (WDTexture computeMiplevelsForExtent: 1@4) equals: 3.

]
