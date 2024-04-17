Class {
	#name : #WDAGPUIntermediateFramebuffersForExtent,
	#superclass : #Object,
	#instVars : [
		'device',
		'extent',
		'sampleCount',
		'initialDepth',
		'depthStencilBuffer',
		'colorBufferTexture',
		'normalGBufferTexture',
		'specularGBufferTexture',
		'hdrTranslucentFramebuffer',
		'hdrOpaqueFramebuffer',
		'depthOnlyFramebuffer',
		'depthStencilBufferSamplingView',
		'depthStencilBufferAttachmentView',
		'ssaoExtent',
		'ssaoPingTexture',
		'ssaoPongTexture',
		'ssaoPingTextureAttachmentView',
		'ssaoPingFramebuffer',
		'ssaoPongTextureAttachmentView',
		'ssaoPongFramebuffer',
		'screenSpaceReflectionTexture',
		'screenSpaceReflectionFramebuffer',
		'staticReflectionTexture',
		'staticReflectionFramebuffer',
		'opaqueColorBufferTexture',
		'screenRoughExtents',
		'screenRoughTextures',
		'screenRoughFramebuffers',
		'bloomExtent',
		'bloomPingTexture',
		'bloomPongTexture',
		'bloomPingTextureAttachmentView',
		'bloomPongTextureAttachmentView',
		'bloomPingFramebuffer',
		'bloomPongFramebuffer'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Renderer'
}

{ #category : #'as yet unclassified' }
WDAGPUIntermediateFramebuffersForExtent class >> for: device resourceCache: resourceCache withExtent: anExtent sampleCount: aSampleCount initialDepth: anInitialDepth [
	^ self basicNew initializeWithDevice: device resourceCache: resourceCache extent: anExtent sampleCount: aSampleCount initialDepth: anInitialDepth; yourself
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> bloomExtent [

	^ bloomExtent
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> bloomPingFramebuffer [

	^ bloomPingFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> bloomPingTexture [

	^ bloomPingTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> bloomPongFramebuffer [

	^ bloomPongFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> bloomPongTexture [

	^ bloomPongTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> colorBufferTexture [
	^ colorBufferTexture
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createBloomFramebuffer [
	| bloomWidth bloomHeight viewDesc |
	bloomWidth := (extent x / 4) floor max: 1.
	bloomHeight := (extent y / 4) floor max: 1.
	bloomExtent := bloomWidth @ bloomHeight.
	bloomPingTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: bloomExtent x;
		height: bloomExtent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).
		
	bloomPongTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: bloomExtent x;
		height: bloomExtent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).

	viewDesc := AGPUTextureViewDescription new.
	bloomPingTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	bloomPingTextureAttachmentView := bloomPingTexture createView: viewDesc.

	viewDesc := AGPUTextureViewDescription new.
	bloomPongTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	bloomPongTextureAttachmentView := bloomPongTexture createView: viewDesc.

	bloomPingFramebuffer := device createFrameBuffer: bloomWidth height: bloomHeight
		colorCount: 1 colorViews: (AGPU packListOfReferences: {bloomPingTextureAttachmentView})
		depthStencilView: nil.
	bloomPongFramebuffer := device createFrameBuffer: bloomWidth height: bloomHeight
		colorCount: 1 colorViews: (AGPU packListOfReferences: {bloomPongTextureAttachmentView})
		depthStencilView: nil.

]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createDepthStencilBuffer: format attachmentFormat: attachmentFormat samplingFormat: samplingFormat [
	| depthStencilBufferSamplingViewDescription depthStencilBufferAttachmentViewDescription |
	depthStencilBuffer := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: format;
		usage_modes: ((AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_STENCIL_ATTACHMENT) bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount;
		clear_value: (AGPUTextureClearValue new
			depth_stencil: (AGPUDepthStencilValue new
				depth: initialDepth;
				yourself);
			yourself);
		yourself).
		
	depthStencilBufferSamplingViewDescription := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: depthStencilBufferSamplingViewDescription.
	depthStencilBufferSamplingViewDescription
		format: samplingFormat;
		usage_mode: AGPU_TEXTURE_USAGE_SAMPLED.
	depthStencilBufferSamplingViewDescription subresource_range aspect: AGPU_TEXTURE_ASPECT_DEPTH.
	depthStencilBufferSamplingView := depthStencilBuffer createView: depthStencilBufferSamplingViewDescription.
	
	depthStencilBufferAttachmentViewDescription := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: depthStencilBufferAttachmentViewDescription.
	depthStencilBufferAttachmentViewDescription
		format: attachmentFormat;
		usage_mode: (AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_STENCIL_ATTACHMENT).
	depthStencilBufferAttachmentView := depthStencilBuffer createView: depthStencilBufferAttachmentViewDescription
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createHdrFramebuffer [
	| viewDesc opaqueColorBufferAttachmentView colorBufferAttachmentView normalGBufferAttachmentView specularGBufferAttachmentView |
	opaqueColorBufferTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount;
		yourself).

	colorBufferTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount;
		yourself).

	normalGBufferTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16_SNORM;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount;
		yourself).

	specularGBufferTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: sampleCount;
		yourself).

	viewDesc := AGPUTextureViewDescription new.
	opaqueColorBufferTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	opaqueColorBufferAttachmentView := opaqueColorBufferTexture createView: viewDesc.
		
	viewDesc := AGPUTextureViewDescription new.
	colorBufferTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	colorBufferAttachmentView := colorBufferTexture createView: viewDesc.

	viewDesc := AGPUTextureViewDescription new.
	normalGBufferTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	normalGBufferAttachmentView := normalGBufferTexture createView: viewDesc.

	viewDesc := AGPUTextureViewDescription new.
	specularGBufferTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	specularGBufferAttachmentView := specularGBufferTexture createView: viewDesc.
	
	depthOnlyFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 0 colorViews: nil
		depthStencilView: depthStencilBufferAttachmentView.	
	hdrOpaqueFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 3 colorViews: (AGPU packListOfReferences: {opaqueColorBufferAttachmentView . normalGBufferAttachmentView . specularGBufferAttachmentView})
		depthStencilView: depthStencilBufferAttachmentView.
	hdrTranslucentFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 1 colorViews: (AGPU packListOfReferences: {colorBufferAttachmentView})
		depthStencilView: depthStencilBufferAttachmentView
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createSSAOFramebuffer [
	| ssaoWidth ssaoHeight viewDesc |
	ssaoWidth := (extent x / 2) floor max: 1.
	ssaoHeight := (extent y / 2) floor max: 1.
	ssaoExtent := ssaoWidth @ ssaoHeight.
	ssaoPingTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: ssaoExtent x;
		height: ssaoExtent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R8_UNORM;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).
		
	ssaoPongTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: ssaoExtent x;
		height: ssaoExtent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R8_UNORM;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).

	viewDesc := AGPUTextureViewDescription new.
	ssaoPingTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	ssaoPingTextureAttachmentView := ssaoPingTexture createView: viewDesc.

	viewDesc := AGPUTextureViewDescription new.
	ssaoPongTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	ssaoPongTextureAttachmentView := ssaoPongTexture createView: viewDesc.

	ssaoPingFramebuffer := device createFrameBuffer: ssaoWidth height: ssaoHeight
		colorCount: 1 colorViews: (AGPU packListOfReferences: {ssaoPingTextureAttachmentView})
		depthStencilView: nil.
	ssaoPongFramebuffer := device createFrameBuffer: ssaoWidth height: ssaoHeight
		colorCount: 1 colorViews: (AGPU packListOfReferences: {ssaoPongTextureAttachmentView})
		depthStencilView: nil.

]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createScreenRoughFramebuffer [
	screenRoughExtents := {256@256 . 128@128 . 64@64 . 64@64}.
	screenRoughTextures := Array new: screenRoughExtents size.
	screenRoughFramebuffers := Array new: screenRoughExtents size.
	
	screenRoughExtents doWithIndex: [ :fbExtent :index |
		| texture viewDesc attachmentView framebuffer |
		texture := device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: fbExtent x;
			height: fbExtent y;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
			usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: 1;
			yourself).

		viewDesc := AGPUTextureViewDescription new.
		texture getFullViewDescription: viewDesc.
		viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
		attachmentView := texture createView: viewDesc.

		framebuffer := device createFrameBuffer: fbExtent x height: fbExtent y
			colorCount: 1 colorViews: (AGPU packListOfReferences: {attachmentView})
			depthStencilView: nil.

		screenRoughTextures at: index put: texture.
		screenRoughFramebuffers at: index put: framebuffer.
	].

]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createScreenSpaceReflectionFramebuffer [
	| viewDesc screenSpaceReflectionTextureAttachmentView |
	screenSpaceReflectionTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).

	viewDesc := AGPUTextureViewDescription new.
	screenSpaceReflectionTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	screenSpaceReflectionTextureAttachmentView := screenSpaceReflectionTexture createView: viewDesc.

	screenSpaceReflectionFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 1 colorViews: (AGPU packListOfReferences: {screenSpaceReflectionTextureAttachmentView})
		depthStencilView: nil.

]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createStaticReflectionFramebuffer [
	| viewDesc staticReflectionTextureAttachmentView |
	staticReflectionTexture := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
		usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1;
		yourself).

	viewDesc := AGPUTextureViewDescription new.
	staticReflectionTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	staticReflectionTextureAttachmentView := staticReflectionTexture createView: viewDesc.

	staticReflectionFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 1 colorViews: (AGPU packListOfReferences: {staticReflectionTextureAttachmentView})
		depthStencilView: nil.

]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> depthOnlyFramebuffer [
	^ depthOnlyFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> depthStencilBufferSamplingView [
	^ depthStencilBufferSamplingView
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> device [

	^ device
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> extent [

	^ extent
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> hdrColorBufferTexture [
	^ colorBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> hdrOpaqueColorBuffer [
	^ opaqueColorBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> hdrOpaqueFramebuffer [
	^ hdrOpaqueFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> hdrTranslucentFramebuffer [
	^ hdrTranslucentFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> initialDepth [
	^ initialDepth
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> initializeWithDevice: aDevice resourceCache: aResourceCache extent: anExtent sampleCount: aSampleCount initialDepth: anInitialDepth [
	device := aDevice.
	extent := anExtent.
	sampleCount := aSampleCount.
	initialDepth := anInitialDepth.
	self
		createDepthStencilBuffer: aResourceCache depthStencilTypelessFormat attachmentFormat: aResourceCache depthStencilFormat samplingFormat: aResourceCache depthStencilSampledFormat;
		createHdrFramebuffer;
		createSSAOFramebuffer;
		createStaticReflectionFramebuffer;
		createScreenRoughFramebuffer;
		createScreenSpaceReflectionFramebuffer;
		createBloomFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> normalGBufferTexture [
	^ normalGBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> opaqueColorBufferTexture [
	^ opaqueColorBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> sampleCount [
	^ sampleCount
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> screenRoughExtents [
	^ screenRoughExtents
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> screenRoughFramebuffers [
	^ screenRoughFramebuffers
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> screenRoughTextures [
	^ screenRoughTextures
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> screenSpaceReflectionFramebuffer [
	^ screenSpaceReflectionFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> screenSpaceReflectionTexture [
	^ screenSpaceReflectionTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> specularGBufferTexture [
	^ specularGBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> ssaoExtent [
	^ ssaoExtent
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> ssaoPingFramebuffer [
	^ ssaoPingFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> ssaoPingTexture [
	^ ssaoPingTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> ssaoPongFramebuffer [
	^ ssaoPongFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> ssaoPongTexture [
	^ ssaoPongTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> staticReflectionFramebuffer [
	^ staticReflectionFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> staticReflectionTexture [
	^ staticReflectionTexture
]
