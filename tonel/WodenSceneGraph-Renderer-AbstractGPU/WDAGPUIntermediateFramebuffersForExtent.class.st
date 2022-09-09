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
		'ssaoPongFramebuffer'
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
WDAGPUIntermediateFramebuffersForExtent >> colorBufferTexture [
	^ colorBufferTexture
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
		usage_modes: (AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_SAMPLED);
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
	depthStencilBufferSamplingView := depthStencilBuffer createView: depthStencilBufferSamplingViewDescription.
	
	depthStencilBufferAttachmentViewDescription := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: depthStencilBufferAttachmentViewDescription.
	depthStencilBufferAttachmentViewDescription
		format: attachmentFormat;
		usage_mode: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT.
	depthStencilBufferAttachmentView := depthStencilBuffer createView: depthStencilBufferAttachmentViewDescription
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createHdrFramebuffer [
	| viewDesc colorBufferAttachmentView normalGBufferAttachmentView specularGBufferAttachmentView |
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
		colorCount: 3 colorViews: (AGPU packListOfReferences: {colorBufferAttachmentView . normalGBufferAttachmentView . specularGBufferAttachmentView})
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
		createDepthStencilBuffer: aResourceCache depthTypelessFormat attachmentFormat: aResourceCache depthFormat samplingFormat: aResourceCache depthSampledFormat;
		createHdrFramebuffer;
		createSSAOFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> normalGBufferTexture [
	^ normalGBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> sampleCount [
	^ sampleCount
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
