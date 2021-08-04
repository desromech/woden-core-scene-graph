"
I am an abstract texture.
"
Class {
	#name : #WDTexture,
	#superclass : #WDRendererCacheableResource,
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
		'data',
		'sampleCount',
		'sampleQuality'
	],
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #utility }
WDTexture class >> computeMiplevelsForExtent: anExtent [
	^ self computeMiplevelsForWidth: anExtent x height: anExtent y
]

{ #category : #utility }
WDTexture class >> computeMiplevelsForWidth: width height: height [
	| result currentWidth currentHeight |
	width isPowerOfTwo ifFalse: [ ^ 1 ].
	height isPowerOfTwo ifFalse: [ ^ 1 ].
	result := 1.
	currentWidth := width.
	currentHeight := height.
	
	[ currentWidth > 1 or: [ currentHeight > 1 ] ] whileTrue: [ 
		result := result + 1.
		currentWidth := currentWidth // 2 max: 1.
		currentHeight := currentHeight // 2 max: 1.
	].
	^ result
]

{ #category : #construction }
WDTexture class >> forColorForm: aForm [
	^ self new setupForColorForm: aForm; yourself
]

{ #category : #construction }
WDTexture class >> forNonColorForm: aForm [
	^ self new setupForNonColorForm: aForm; yourself
]

{ #category : #construction }
WDTexture class >> forNormalMapForm: aForm [
	^ self new setupForNormalMapForm: aForm; yourself
]

{ #category : #accessing }
WDTexture >> data [

	^ data
]

{ #category : #accessing }
WDTexture >> data: anObject [

	data := anObject
]

{ #category : #accessing }
WDTexture >> dataKind [

	^ dataKind
]

{ #category : #accessing }
WDTexture >> dataKind: aDataKind [
	dataKind := aDataKind asTextureDataKind
]

{ #category : #accessing }
WDTexture >> depth [

	^ depth
]

{ #category : #accessing }
WDTexture >> depth: anObject [

	depth := anObject
]

{ #category : #accessing }
WDTexture >> format [

	^ format
]

{ #category : #accessing }
WDTexture >> format: aTextureFormat [
	format := aTextureFormat asTextureFormat
]

{ #category : #accessing }
WDTexture >> height [

	^ height
]

{ #category : #accessing }
WDTexture >> height: anObject [

	height := anObject
]

{ #category : #initialization }
WDTexture >> initialize [
	super initialize.
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

{ #category : #accessing }
WDTexture >> layers [

	^ layers
]

{ #category : #accessing }
WDTexture >> layers: anObject [

	layers := anObject
]

{ #category : #accessing }
WDTexture >> miplevels [

	^ miplevels
]

{ #category : #accessing }
WDTexture >> miplevels: anObject [

	miplevels := anObject
]

{ #category : #accessing }
WDTexture >> sampleCount [

	^ sampleCount
]

{ #category : #accessing }
WDTexture >> sampleCount: anObject [

	sampleCount := anObject
]

{ #category : #accessing }
WDTexture >> sampleQuality [

	^ sampleQuality
]

{ #category : #accessing }
WDTexture >> sampleQuality: anObject [

	sampleQuality := anObject
]

{ #category : #initialization }
WDTexture >> setupForColorForm: aForm [
	self
		dataKind: WDTextureDataKindColor;
		format: WDTextureFormatB8G8R8A8UNormSRGB;
		setupForFormCommon: aForm
]

{ #category : #private }
WDTexture >> setupForFormCommon: aForm [
	self
		type: WDTextureType2D;
		width: aForm width;
		height: aForm height;
		depth: 1;
		layers: 1;
		miplevels: (self class computeMiplevelsForExtent: aForm extent);
		sampleCount: 1;
		data: aForm;
		changed
]

{ #category : #initialization }
WDTexture >> setupForNonColorForm: aForm [
	self
		dataKind: WDTextureDataKindNonColor;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFormCommon: aForm
]

{ #category : #initialization }
WDTexture >> setupForNormalMapForm: aForm [
	self
		dataKind: WDTextureDataKindNormalMap;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFormCommon: aForm
]

{ #category : #accessing }
WDTexture >> type [

	^ type
]

{ #category : #accessing }
WDTexture >> type: aTextureType [
	type := aTextureType asTextureType
]

{ #category : #accessing }
WDTexture >> usageMode [

	^ usageMode
]

{ #category : #accessing }
WDTexture >> usageMode: aTextureUsageMode [
	usageMode := aTextureUsageMode asTextureUsageMode
]

{ #category : #accessing }
WDTexture >> width [

	^ width
]

{ #category : #accessing }
WDTexture >> width: anObject [

	width := anObject
]
