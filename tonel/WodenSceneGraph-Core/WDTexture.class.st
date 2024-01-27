"
I am an abstract texture.
"
Class {
	#name : #WDTexture,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'name',
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

{ #category : #'as yet unclassified' }
WDTexture class >> diffuseLightProbeWithSize: size forEnvironmentMap: environmentMap [
	^ self new setupDiffuseLightProbeWithSize: size forEnvironmentMap: environmentMap; yourself
]

{ #category : #'as yet unclassified' }
WDTexture class >> environmentMapWithSize: size forHDRITexture: texture [	
	^ self new setupEnvironmentMapWithSize: size forHDRITexture: texture; yourself
]

{ #category : #construction }
WDTexture class >> forColorFileReference: aFileReference [
	^ self new setupForColorFileReference: aFileReference; yourself
]

{ #category : #construction }
WDTexture class >> forColorForm: aForm [
	^ self new setupForColorForm: aForm; yourself
]

{ #category : #construction }
WDTexture class >> forFitsFileReference: aFileReference [
	^ self new setupForFitsFileReference: aFileReference; yourself
]

{ #category : #construction }
WDTexture class >> forHDRIFileReference: aFileReference [
	^ self new setupForHDRIFileReference: aFileReference; yourself
]

{ #category : #construction }
WDTexture class >> forNonColorFileReference: aFileReference [
	^ self new setupForNonColorFileReference: aFileReference; yourself
]

{ #category : #construction }
WDTexture class >> forNonColorForm: aForm [
	^ self new setupForNonColorForm: aForm; yourself
]

{ #category : #construction }
WDTexture class >> forNormalMapFileReference: aFileReference [
	^ self new setupForNormalMapFileReference: aFileReference; yourself
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

{ #category : #serialization }
WDTexture class >> loadFromJson: jsonData inDirectory: directory [
	^ (self solveFileName: jsonData inDirectory: directory)
		ifNotNil: [ :solved | self forColorFileReference: solved ]
]

{ #category : #serialization }
WDTexture class >> loadNonColorFromJson: jsonData inDirectory: directory [
	^ (self solveFileName: jsonData inDirectory: directory)
		ifNotNil: [ :solved | self forNonColorFileReference: solved ]
]

{ #category : #serialization }
WDTexture class >> loadNormalMapFromJson: jsonData inDirectory: directory [
	^ (self solveFileName: jsonData inDirectory: directory)
		ifNotNil: [ :solved | self forNormalMapFileReference: solved ]
]

{ #category : #serialization }
WDTexture class >> solveFileName: fileName inDirectory: directory [
	| fileReference |
	fileName ifNil: [ ^ nil ].
	fileReference := fileName asFileReference.
	directory ifNotNil: [
		fileReference := directory asFileReference resolve: fileReference
	].
	fileReference exists ifFalse: [ ^ nil ].
	^ fileReference
]

{ #category : #'as yet unclassified' }
WDTexture class >> specularLightProbeWithSize: size forEnvironmentMap: environmentMap [
	^ self new setupSpecularLightProbeWithSize: size forEnvironmentMap: environmentMap; yourself
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

{ #category : #'as yet unclassified' }
WDTexture >> makeThumbnail [
	data isForm ifTrue: [ ^ data scaledToSize: 16@16 ].
	^ nil
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
WDTexture >> name [

	^ name
]

{ #category : #accessing }
WDTexture >> name: anObject [

	name := anObject
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
WDTexture >> setupDiffuseLightProbeWithSize: size forEnvironmentMap: texture [
	self
		dataKind: WDTextureDataKindDiffuseLightProbe;
		format: WDTextureFormatR16G16B16A16Float;
		type: WDTextureTypeCube;
		width: size;
		height: size;
		depth: 1;
		layers: 6;
		miplevels: 1;
		sampleCount: 1;
		data: texture;
		changed

]

{ #category : #initialization }
WDTexture >> setupEnvironmentMapWithSize: size forHDRITexture: texture [
	self
		dataKind: WDTextureDataKindCubeEnvironmentMap;
		format: WDTextureFormatR16G16B16A16Float;
		type: WDTextureTypeCube;
		width: size;
		height: size;
		depth: 1;
		layers: 6;
		miplevels: 1;
		sampleCount: 1;
		data: texture;
		changed

]

{ #category : #initialization }
WDTexture >> setupForColorFileReference: aFileReference [
	self
		dataKind: WDTextureDataKindColor;
		format: WDTextureFormatB8G8R8A8UNormSRGB;
		setupForFileReferenceCommon: aFileReference
]

{ #category : #initialization }
WDTexture >> setupForColorForm: aForm [
	self
		dataKind: WDTextureDataKindColor;
		format: WDTextureFormatB8G8R8A8UNormSRGB;
		setupForFormCommon: aForm
]

{ #category : #private }
WDTexture >> setupForFileReferenceCommon: aFileReference [
	self flag: 'TODO: Add support for asynchronous loading'.
	self setupForFormCommon: (ImageReadWriter formFromFileNamed: aFileReference)
]

{ #category : #initialization }
WDTexture >> setupForFitsFileReference: aFileReference [
	self flag: 'TODO: Add support for asynchronous loading'.
	
	aFileReference binaryReadStreamDo: [ :in |
		| fitsHeader fitsTextureData |
		fitsHeader := WDFitsHeaderReader new
			stream: in;
			readHeader;
			yourself.
		fitsTextureData := fitsHeader readTextureData.

		self
			dataKind: WDTextureDataKindNonColor;
			format: fitsHeader textureFormat;
			type: fitsHeader textureType;
			width: fitsTextureData width;
			height: fitsTextureData height;
			depth: fitsTextureData depth;
			layers: 1;
			miplevels: 1;
			sampleCount: 1;
			data: fitsTextureData;
			changed
	].
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

{ #category : #private }
WDTexture >> setupForHDRI: hdri [
	self
		type: WDTextureType2D;
		width: hdri width;
		height: hdri height;
		depth: 1;
		layers: 1;
		miplevels: 1;
		sampleCount: 1;
		data: hdri;
		changed
]

{ #category : #initialization }
WDTexture >> setupForHDRIFileReference: aFileReference [
	self
		dataKind: WDTextureDataKindHDRI;
		format: WDTextureFormatR8G8B8A8UNorm.
		
	
	self flag: 'TODO: Add support for asynchronous loading'.
	self setupForHDRI: (AGPURadianceHDRLoader tryToLoadFromFileReference: aFileReference)
]

{ #category : #initialization }
WDTexture >> setupForNonColorFileReference: aFileReference [
	self
		dataKind: WDTextureDataKindNonColor;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFileReferenceCommon: aFileReference
]

{ #category : #initialization }
WDTexture >> setupForNonColorForm: aForm [
	self
		dataKind: WDTextureDataKindNonColor;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFormCommon: aForm
]

{ #category : #initialization }
WDTexture >> setupForNormalMapFileReference: aFileReference [
	self
		dataKind: WDTextureDataKindNormalMap;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFileReferenceCommon: aFileReference
]

{ #category : #initialization }
WDTexture >> setupForNormalMapForm: aForm [
	self
		dataKind: WDTextureDataKindNormalMap;
		format: WDTextureFormatB8G8R8A8UNorm;
		setupForFormCommon: aForm
]

{ #category : #initialization }
WDTexture >> setupSpecularLightProbeWithSize: size forEnvironmentMap: texture [
	self
		dataKind: WDTextureDataKindSpecularLightProbe;
		format: WDTextureFormatR16G16B16A16Float;
		type: WDTextureTypeCube;
		width: size;
		height: size;
		depth: 1;
		layers: 6;
		miplevels: (self class computeMiplevelsForWidth: size height: size);
		sampleCount: 1;
		data: texture;
		changed

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
