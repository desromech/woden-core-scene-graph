"
I am an abstract texture.
"
Class {
	#name : #WDTexture,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'description',
		'data'
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

{ #category : #'as yet unclassified' }
WDTexture class >> forReadedColorBufferWithExtent: anExtent [
	^ (self forColorForm: (Form extent: anExtent depth: 32))
		usageMode: WDTextureUsageModeReadedColorAttachment;
		miplevels: 1;
		yourself
]

{ #category : #'as yet unclassified' }
WDTexture class >> forSampledColorBufferWithExtent: anExtent [
	^ self new
		type: WDTextureType2D;
		dataKind: WDTextureDataKindColor;
		format: WDTextureFormatB8G8R8A8UNormSRGB;
		width: anExtent x;
		height: anExtent y;
		depth: 1;
		layers: 1;
		usageMode: WDTextureUsageModeSampledColorAttachment;
		miplevels: 1;
		sampleCount: 1;
		changed;
		yourself
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
	^ description dataKind
]

{ #category : #accessing }
WDTexture >> dataKind: aDataKind [
	description dataKind: aDataKind
]

{ #category : #accessing }
WDTexture >> depth [
	^ description depth
]

{ #category : #accessing }
WDTexture >> depth: anInteger [
	description depth: anInteger
]

{ #category : #accessing }
WDTexture >> description [
	^ description shallowCopy
]

{ #category : #accessing }
WDTexture >> description: aDescription [
	description := aDescription shallowCopy
]

{ #category : #accessing }
WDTexture >> format [
	^ description format
]

{ #category : #accessing }
WDTexture >> format: aTextureFormat [
	description format: aTextureFormat
]

{ #category : #accessing }
WDTexture >> height [
	^ description height
]

{ #category : #accessing }
WDTexture >> height: anInteger [
	description height: anInteger
]

{ #category : #initialization }
WDTexture >> initialize [
	super initialize.
	description := WDTextureDescription new.
]

{ #category : #accessing }
WDTexture >> layers [
	^ description layers
]

{ #category : #accessing }
WDTexture >> layers: anInteger [
	description layers: anInteger
]

{ #category : #accessing }
WDTexture >> miplevels [
	^ description miplevels
]

{ #category : #accessing }
WDTexture >> miplevels: anInteger [
	description miplevels: anInteger
]

{ #category : #accessing }
WDTexture >> sampleCount [
	^ description sampleCount
]

{ #category : #accessing }
WDTexture >> sampleCount: anInteger [
	description sampleCount: anInteger
]

{ #category : #accessing }
WDTexture >> sampleQuality [
	^ description sampleQuality
]

{ #category : #accessing }
WDTexture >> sampleQuality: anInteger [
	description sampleQuality: anInteger
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
	^ description type
]

{ #category : #accessing }
WDTexture >> type: aTextureType [
	description type: aTextureType
]

{ #category : #accessing }
WDTexture >> usageMode [
	^ description usageMode
]

{ #category : #accessing }
WDTexture >> usageMode: aTextureUsageMode [
	description usageMode: aTextureUsageMode
]

{ #category : #accessing }
WDTexture >> width [
	^ description width
]

{ #category : #accessing }
WDTexture >> width: anInteger [
	description width: anInteger
]
