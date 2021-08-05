"
I am a cache for connecting session independent woden resources with device and session specific resources.
"
Class {
	#name : #WDAGPUSceneRendererResourceCache,
	#superclass : #Object,
	#instVars : [
		'device',
		'textureUploader',
		'textures',
		'framebuffers',
		'buffers',
		'viewportOutputRenderPass',
		'rendererShaderSignature'
	],
	#classVars : [
		'TextureFormatMap',
		'TextureMainUsageModeMap',
		'TextureTypeMap',
		'TextureUsageModesMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #'instance creation' }
WDAGPUSceneRendererResourceCache class >> for: aDevice [
	^ self for: aDevice withTextureUploader: (AGPUTextureUploader for: aDevice)
]

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererResourceCache class >> for: device withTextureUploader: textureUploader [
	^ self basicNew initializeWithDevice: device withTextureUploader: textureUploader
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache class >> initialize [
	TextureFormatMap := Dictionary newFromPairs: {
		WDTextureFormatUnknown uniqueInstance . AGPU_TEXTURE_FORMAT_UNKNOWN.
		WDTextureFormatB8G8R8A8UNorm uniqueInstance . AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM.
		WDTextureFormatB8G8R8A8UNormSRGB uniqueInstance . AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.
		WDTextureFormatR16G16B16A16Float uniqueInstance . AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT.
	}.
	
	TextureTypeMap := Dictionary newFromPairs: {
		WDTextureTypeUnknown uniqueInstance . AGPU_TEXTURE_UNKNOWN.
		WDTextureType1D uniqueInstance . AGPU_TEXTURE_1D.
		WDTextureType2D uniqueInstance . AGPU_TEXTURE_2D.
		WDTextureType3D uniqueInstance . AGPU_TEXTURE_3D.
		WDTextureTypeCube uniqueInstance . AGPU_TEXTURE_CUBE.
	}.
	
	TextureUsageModesMap := Dictionary newFromPairs: {
		WDTextureUsageModeDeviceLocalColorAttachment uniqueInstance . AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
		WDTextureUsageModeReadedColorAttachment uniqueInstance . AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_COPY_SOURCE.
		WDTextureUsageModeSampledColorAttachment uniqueInstance . ((AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_COPY_SOURCE) bitOr: AGPU_TEXTURE_USAGE_COPY_DESTINATION) bitOr: AGPU_TEXTURE_USAGE_SAMPLED.
		WDTextureUsageModeStaticSampled uniqueInstance . (AGPU_TEXTURE_USAGE_COPY_SOURCE bitOr: AGPU_TEXTURE_USAGE_COPY_DESTINATION) bitOr: AGPU_TEXTURE_USAGE_SAMPLED.
	}.
	
	TextureMainUsageModeMap := Dictionary newFromPairs: {
		WDTextureUsageModeDeviceLocalColorAttachment uniqueInstance . AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
		WDTextureUsageModeReadedColorAttachment uniqueInstance . AGPU_TEXTURE_USAGE_COPY_SOURCE.
		WDTextureUsageModeSampledColorAttachment uniqueInstance . AGPU_TEXTURE_USAGE_SAMPLED.
		WDTextureUsageModeStaticSampled uniqueInstance . AGPU_TEXTURE_USAGE_SAMPLED.
	}.

]

{ #category : #'as yet unclassified' }
WDAGPUSceneRendererResourceCache >> convertTextureDescription: description [
	^ AGPUTextureDescription new
		type: (TextureTypeMap at: description type);
		width: description width;
		height: description height;
		depth: description depth;
		layers: description layers;
		miplevels: description miplevels;
		sample_count: description sampleCount;
		format: (TextureFormatMap at: description format);
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: (TextureUsageModesMap at: description usageMode);
		main_usage_mode: (TextureMainUsageModeMap at: description usageMode);
		yourself
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> device [
	^ device
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> initializeWithDevice: aDevice withTextureUploader: aTextureUploader [
	device := aDevice.
	textureUploader := aTextureUploader.
	textures := WeakKeyDictionary new.
	framebuffers := WeakKeyDictionary new.
	buffers := WeakKeyDictionary new.
	rendererShaderSignature := WDAGPURendererShaderSignature for: device
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> rendererShaderSignature [
	^ rendererShaderSignature
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> textureUploader [
	^ textureUploader
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validBufferHandleFor: aWDBinaryBuffer [
	self halt
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validColorAttachmentTextureViewFor: aWDTexture [
	| textureHandle viewDescription range |
	textureHandle := self validTextureHandleFor: aWDTexture.
	
	viewDescription := AGPUTextureViewDescription new.
	textureHandle getFullViewDescription: viewDescription.
	range := viewDescription subresource_range.
	range
		layer_count: 1;
		level_count: 1.
	viewDescription
		subresource_range: range;
		usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	^ textureHandle createView: viewDescription
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validDepthStencilAttachmentTextureViewFor: aWDTexture [
	| textureHandle viewDescription range usageMode |
	textureHandle := self validTextureHandleFor: aWDTexture.
	
	viewDescription := AGPUTextureViewDescription new.
	textureHandle getFullViewDescription: viewDescription.
	range := viewDescription subresource_range.
	range
		layer_count: 1;
		level_count: 1.
		
	usageMode := 0.
	aWDTexture format hasDepthComponent ifTrue: [ 
		usageMode := usageMode bitOr: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT.
	].

	aWDTexture format hasStencilComponent ifTrue: [ 
		usageMode := usageMode bitOr: AGPU_TEXTURE_USAGE_STENCIL_ATTACHMENT.
	].

	viewDescription
		subresource_range: range;
		usage_mode: usageMode.
	^ textureHandle createView: viewDescription
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validFramebufferFor: aWDFramebuffer [
	| cachedFramebuffer colorBufferViews depthStencilView |
	cachedFramebuffer := textures at: aWDFramebuffer ifAbsentPut: [ WDAGPUSceneRendererCachedResource new ].
	cachedFramebuffer modificationCount == aWDFramebuffer modificationCount ifTrue: [ ^ cachedFramebuffer handle ].
	
	colorBufferViews := aWDFramebuffer colorAttachments collect: [ :each |
		self validColorAttachmentTextureViewFor: each
	].
	depthStencilView := aWDFramebuffer depthStencilAttachment ifNotNil: [ :attachment |
		self validDepthStencilAttachmentTextureViewFor: attachment
	].
	
	cachedFramebuffer handle: (device createFrameBuffer: aWDFramebuffer width height: aWDFramebuffer height colorCount: colorBufferViews size colorViews: (AGPU packListOfReferences: colorBufferViews) depthStencilView: depthStencilView).

	^ cachedFramebuffer handle
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validTextureHandleFor: aWDTexture [
	| cachedTexture |
	cachedTexture := textures at: aWDTexture ifAbsentPut: [ WDAGPUSceneRendererCachedResource new ].
	cachedTexture modificationCount == aWDTexture modificationCount ifTrue: [ ^ cachedTexture handle ].
	
	cachedTexture description = aWDTexture description ifFalse: [
		| newDescription |
		newDescription := aWDTexture description.
		cachedTexture handle: (device createTexture: (self convertTextureDescription: newDescription)).
		cachedTexture description: newDescription
	].

	aWDTexture data ifNotNil: [ :dataToUpload |
		aWDTexture usageMode isStaticSampled ifTrue: [ 
			self halt.
		]
	].
	
	cachedTexture modificationCount: aWDTexture modificationCount.
	^ cachedTexture handle
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> viewportOutputRenderPass [
	| colorAttachment |
	viewportOutputRenderPass ifNotNil: [ ^ viewportOutputRenderPass ].
	
	^ [
		| renderpassDescription |
		colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
		colorAttachment
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: Color blue asAGPUColor4f;
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		viewportOutputRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]
