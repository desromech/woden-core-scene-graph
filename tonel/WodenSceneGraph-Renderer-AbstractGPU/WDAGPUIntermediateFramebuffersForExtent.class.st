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
		'hdrFramebuffer'
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
WDAGPUIntermediateFramebuffersForExtent >> createDepthStencilBuffer: format [
	depthStencilBuffer := device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: format;
		usage_modes: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT;
		main_usage_mode: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT;
		sample_count: sampleCount;
		clear_value: (AGPUTextureClearValue new
			depth_stencil: (AGPUDepthStencilValue new
				depth: initialDepth;
				yourself);
			yourself);
		yourself)
]

{ #category : #initialization }
WDAGPUIntermediateFramebuffersForExtent >> createHdrFramebuffer [
	| viewDesc colorBufferAttachmentView depthStencilBufferView |
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
		
	viewDesc := AGPUTextureViewDescription new.
	colorBufferTexture getFullViewDescription: viewDesc.
	viewDesc usage_mode: AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT.
	colorBufferAttachmentView := colorBufferTexture createView: viewDesc.
	
	viewDesc := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: viewDesc.
	viewDesc usage_mode:
		(viewDesc usage_mode bitAnd: (AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_STENCIL_ATTACHMENT)).
	depthStencilBufferView := depthStencilBuffer createView: viewDesc.
	
	hdrFramebuffer := device createFrameBuffer: extent x height: extent y
		colorCount: 1 colorViews: (AGPU packListOfReferences: {colorBufferAttachmentView})
		depthStencilView: depthStencilBufferView
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> device [

	^ device
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> extent [

	^ extent
]

{ #category : #'as yet unclassified' }
WDAGPUIntermediateFramebuffersForExtent >> hdrColorBufferTexture [
	^ colorBufferTexture
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> hdrFramebuffer [
	^ hdrFramebuffer
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
		createDepthStencilBuffer: aResourceCache depthFormat;
		createHdrFramebuffer
]

{ #category : #accessing }
WDAGPUIntermediateFramebuffersForExtent >> sampleCount [
	^ sampleCount
]
