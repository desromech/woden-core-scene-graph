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

{ #category : #tests }
WDTextureTest >> testForColorForm [
	| colorForm texture |
	colorForm := Form extent: 16@16 depth: 32.
	texture := WDTexture forColorForm: colorForm.
	self assert: texture dataKind isColorData.
	self assert: texture format isB8G8R8A8UNormSRGB.
	self assert: texture type is2DTextureType.
	self assert: texture width equals: 16.
	self assert: texture height equals: 16.
	self assert: texture depth equals: 1.
	self assert: texture layers equals: 1.
	self assert: texture miplevels equals: 5.
	self deny: texture isRenderTarget.
	self assert: texture data equals: colorForm.
]

{ #category : #tests }
WDTextureTest >> testForNonColorForm [
	| colorForm texture |
	colorForm := Form extent: 16@16 depth: 32.
	texture := WDTexture forNonColorForm: colorForm.
	self assert: texture dataKind isNonColorData.
	self assert: texture format isB8G8R8A8UNorm.
	self assert: texture type is2DTextureType.
	self assert: texture width equals: 16.
	self assert: texture height equals: 16.
	self assert: texture depth equals: 1.
	self assert: texture layers equals: 1.
	self assert: texture miplevels equals: 5.
	self deny: texture isRenderTarget.
	self assert: texture data equals: colorForm.
]

{ #category : #tests }
WDTextureTest >> testForNormalMapForm [
	| colorForm texture |
	colorForm := Form extent: 16@16 depth: 32.
	texture := WDTexture forNormalMapForm: colorForm.
	self assert: texture dataKind isNormalMapData.
	self assert: texture format isB8G8R8A8UNorm.
	self assert: texture type is2DTextureType.
	self assert: texture width equals: 16.
	self assert: texture height equals: 16.
	self assert: texture depth equals: 1.
	self assert: texture layers equals: 1.
	self assert: texture miplevels equals: 5.
	self deny: texture isRenderTarget.
	self assert: texture data equals: colorForm.
]
