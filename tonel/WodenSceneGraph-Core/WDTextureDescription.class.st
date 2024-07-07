"
I hold a description for creating a texture handle.
"
Class {
	#name : 'WDTextureDescription',
	#superclass : 'Object',
	#instVars : [
		'dataKind',
		'type',
		'format',
		'usageMode',
		'width',
		'depth',
		'height',
		'layers',
		'miplevels',
		'sampleCount',
		'sampleQuality'
	],
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'comparing' }
WDTextureDescription >> = other [
	^ self class == other class and: [
	dataKind = other dataKind and: [
	type = other type and: [
	format = other format and: [
	usageMode = other usageMode and: [
	width = other width and: [
	depth = other depth and: [
	height = other height and: [
	layers = other layers and: [
	miplevels = other miplevels and: [
	sampleCount = other sampleCount and: [
	sampleQuality = other sampleQuality ]]]]]]]]]]]
]

{ #category : 'accessing' }
WDTextureDescription >> dataKind [

	^ dataKind
]

{ #category : 'accessing' }
WDTextureDescription >> dataKind: aDataKind [
	dataKind := aDataKind asTextureDataKind
]

{ #category : 'accessing' }
WDTextureDescription >> depth [

	^ depth
]

{ #category : 'accessing' }
WDTextureDescription >> depth: anObject [

	depth := anObject
]

{ #category : 'accessing' }
WDTextureDescription >> format [

	^ format
]

{ #category : 'accessing' }
WDTextureDescription >> format: aTextureFormat [
	format := aTextureFormat asTextureFormat
]

{ #category : 'comparing' }
WDTextureDescription >> hash [
	^ self class identityHash bitXor: (
	dataKind hash bitXor: (
	type hash bitXor: (
	format hash bitXor: (
	usageMode hash bitXor: (
	width hash bitXor: (
	depth hash bitXor: (
	height hash bitXor: (
	layers hash bitXor: (
	miplevels hash bitXor: (
	sampleCount hash bitXor: (
	sampleQuality hash)))))))))))
]

{ #category : 'accessing' }
WDTextureDescription >> height [

	^ height
]

{ #category : 'accessing' }
WDTextureDescription >> height: anObject [

	height := anObject
]

{ #category : 'initialization' }
WDTextureDescription >> initialize [
	self
		dataKind: WDTextureDataKindColor;
		type: WDTextureTypeUnknown;
		format: WDTextureFormatUnknown;
		usageMode: WDTextureUsageModeStaticSampled.
	width := 0.
	height := 0.
	depth := 0.
	layers := 0.
	miplevels := 0.
	sampleCount := 1.
	sampleQuality := 0.
]

{ #category : 'accessing' }
WDTextureDescription >> layers [

	^ layers
]

{ #category : 'accessing' }
WDTextureDescription >> layers: anObject [

	layers := anObject
]

{ #category : 'accessing' }
WDTextureDescription >> miplevels [

	^ miplevels
]

{ #category : 'accessing' }
WDTextureDescription >> miplevels: anObject [

	miplevels := anObject
]

{ #category : 'accessing' }
WDTextureDescription >> sampleCount [

	^ sampleCount
]

{ #category : 'accessing' }
WDTextureDescription >> sampleCount: anObject [

	sampleCount := anObject
]

{ #category : 'accessing' }
WDTextureDescription >> sampleQuality [

	^ sampleQuality
]

{ #category : 'accessing' }
WDTextureDescription >> sampleQuality: anObject [

	sampleQuality := anObject
]

{ #category : 'accessing' }
WDTextureDescription >> type [

	^ type
]

{ #category : 'accessing' }
WDTextureDescription >> type: aTextureType [
	type := aTextureType asTextureType
]

{ #category : 'accessing' }
WDTextureDescription >> usageMode [

	^ usageMode
]

{ #category : 'accessing' }
WDTextureDescription >> usageMode: aTextureUsageMode [
	usageMode := aTextureUsageMode asTextureUsageMode
]

{ #category : 'accessing' }
WDTextureDescription >> width [

	^ width
]

{ #category : 'accessing' }
WDTextureDescription >> width: anObject [

	width := anObject
]
