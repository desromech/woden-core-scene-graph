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
		'rendererShaderSignature',
		'vertexBindings',
		'vertexLayouts',
		'triangleVertexShader',
		'triangleFragmentShader'
	],
	#classVars : [
		'AccessorTypeIntoTextureFormatMap',
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
	
	AccessorTypeIntoTextureFormatMap := Dictionary newFromPairs: {
		{ false . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_FLOAT.
		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_FLOAT.
		{ false . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_FLOAT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_FLOAT.

		{ true . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_FLOAT.
		{ true . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_FLOAT.
		{ true . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_FLOAT.
		{ true . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorFloat32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_FLOAT.

		{ false . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_UINT.
		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_UINT.
		{ false . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_UINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_UINT.

		{ false . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_SINT.
		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_SINT.
		{ false . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_SINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_SINT.
	}.
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> compileShader: sourceText type: shaderType [
	| shaderCompiler |
	shaderCompiler := device createOfflineShaderCompiler.
^ [
		shaderCompiler
			setShaderSource: AGPU_SHADER_LANGUAGE_VGLSL stage: shaderType sourceText: sourceText sourceTextLength: sourceText size;
			compileShader: AGPU_SHADER_LANGUAGE_DEVICE_SHADER options: '';
			getResultAsShader
		] on: AGPUError do: [ :e |
			e errorCode = AGPU_COMPILATION_ERROR ifTrue: [
				| logLength logBuffer compilationError |
				logLength := shaderCompiler getCompilationLogLength.
				logBuffer := ExternalAddress allocate: logLength + 1.
				compilationError := [
					shaderCompiler getCompilationLog: logLength + 1 buffer: logBuffer.
					logBuffer readString.
				] ensure: [ logBuffer free ].
				self error: compilationError
			] ifFalse: [
				e pass
			]
		]
]

{ #category : #private }
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
	vertexBindings := WeakKeyDictionary new.
	rendererShaderSignature := WDAGPURendererShaderSignature for: device.
	vertexLayouts := Dictionary new.
	
	triangleVertexShader := self compileShader: self triangleVertexShaderSource type: AGPU_VERTEX_SHADER.
	triangleFragmentShader := self compileShader: self triangleFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> rendererShaderSignature [
	^ rendererShaderSignature
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> textureUploader [
	^ textureUploader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> triangleFragmentShader [
	^ triangleFragmentShader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> triangleFragmentShaderSource [
	^ '
#version 450
#line 5

layout(location = 0) in vec4 inColor;

layout(location = 0) out vec4 outColor;

void main()
{ 
	outColor = inColor;
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> triangleVertexShader [
	^ triangleVertexShader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> triangleVertexShaderSource [
	^ '
#version 450
#line 5

layout(set=1, binding=0, std140) uniform CameraStateBlock	
{
	mat4 transformationMatrix;
	mat4 inverseTransformationMatrix;

	mat4 projectionMatrix;
	float currentTime;
	float exposure;
} CameraState;

layout(set=3, binding=0, std140) uniform ObjectStateBlock
{
	mat4 transformationMatrix;
	mat4 inverseTransformationMatrix;
} ObjectState;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec4 inColor;

layout(location = 0) out vec4 outColor;

void main()
{
	outColor = inColor;
	gl_Position = CameraState.projectionMatrix * (CameraState.inverseTransformationMatrix * (ObjectState.transformationMatrix * vec4(inPosition, 1.0)));
}
'
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validBufferHandleFor: aWDBinaryBuffer [
	| cachedBuffer requiredCapacity |
	cachedBuffer := textures at: aWDBinaryBuffer ifAbsentPut: [ WDAGPUSceneRendererCachedResource new ].
	cachedBuffer modificationCount == aWDBinaryBuffer modificationCount ifTrue: [ ^ cachedBuffer handle ].
	
	requiredCapacity := aWDBinaryBuffer data size.
	(cachedBuffer description isNil or: [ cachedBuffer description < requiredCapacity ]) ifTrue: [
		cachedBuffer handle: (device createBuffer: (AGPUBufferDescription new
			size: requiredCapacity;
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			usage_modes: (AGPU_ARRAY_BUFFER bitOr: AGPU_ELEMENT_ARRAY_BUFFER);
			main_usage_mode: (AGPU_ARRAY_BUFFER bitOr: AGPU_ELEMENT_ARRAY_BUFFER);
			stride: 0;
			yourself		
		) initial_data: aWDBinaryBuffer data).
		cachedBuffer description: requiredCapacity
	] ifFalse: [
		cachedBuffer handle uploadBufferData: 0 size: requiredCapacity data: aWDBinaryBuffer data
	].
	
	cachedBuffer modificationCount: aWDBinaryBuffer modificationCount.
	^ cachedBuffer handle
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validBufferHandleForAccessor: aWDBinaryBufferAccessor [
	^ self validBufferHandleFor: aWDBinaryBufferAccessor bufferView buffer
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
			dataToUpload uploadIntoWodenTexture: aWDTexture agpuHandle: cachedTexture handle withWodenSceneRendererResourceCache: self
		]
	].
	
	cachedTexture modificationCount: aWDTexture modificationCount.
	^ cachedTexture handle
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validVertexBindingFor: aWDVertexBufferBinding [
	| cachedVertexBinding attributeBuffers offsets |
	cachedVertexBinding := vertexBindings at: aWDVertexBufferBinding ifAbsentPut: [ WDAGPUSceneRendererCachedResource new ].
	cachedVertexBinding modificationCount == aWDVertexBufferBinding modificationCount ifTrue: [ ^ cachedVertexBinding handle ].
	
	attributeBuffers := aWDVertexBufferBinding attributes collect: [ :each | self validBufferHandleForAccessor: each accessor ].
	
	cachedVertexBinding handle ifNil: [
		| layout |
		layout := self validVertexLayoutForVertexBinding: aWDVertexBufferBinding.
		cachedVertexBinding handle: {layout. device createVertexBinding: layout}.
	].

	offsets := ByteArray new: aWDVertexBufferBinding attributes size * 4.
	aWDVertexBufferBinding attributes doWithIndex: [ :attribute :index |
		| accessor |
		accessor := attribute accessor.
		offsets at: index*4 - 3 put: accessor byteOffset + accessor bufferView byteOffset
	].

	cachedVertexBinding handle second bindVertexBuffersWithOffsets: attributeBuffers size vertex_buffers: (AGPU packListOfReferences: attributeBuffers) offsets: offsets.
	
	cachedVertexBinding modificationCount: aWDVertexBufferBinding modificationCount.
	^ cachedVertexBinding handle
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validVertexLayoutForVertexBinding: vertexBinding [
	| layoutDescriptors |
	layoutDescriptors := vertexBinding attributes collectWithIndex: [ :each :index | self vertexLayoutDescriptorFor: each bufferIndex: index - 1].
	^ vertexLayouts at: layoutDescriptors ifAbsentPut: [
		| layoutSpec strides |
		strides := ByteArray new: layoutDescriptors size * 4.
		layoutSpec := ByteArray streamContents: [ :out |
			layoutDescriptors doWithIndex: [ :each :index |
				out nextPutAll: each asAGPUVertexAttribDescriptionData.
				strides unsignedLongAt: index*4 - 3 put: each stride
			]
		].
	
		device createVertexLayout
			addVertexAttributeBindings: layoutDescriptors size vertex_strides: strides attribute_count: layoutDescriptors size attributes: (AGPUVertexAttribDescription fromHandle: layoutSpec);
			yourself
	].

]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> vertexLayoutDescriptorFor: vertexBindingAttribute bufferIndex: bufferIndex [
	| accessor format |
	accessor := vertexBindingAttribute accessor.
	format := AccessorTypeIntoTextureFormatMap at: {accessor normalized . accessor type . accessor componentType }.

	^ WDAGPUVertexAttributeDescriptor new
		format: format;
		binding: vertexBindingAttribute location; 
		stride: accessor type componentCount * accessor componentType size;
		buffer: bufferIndex;
		divisor: 0;
		yourself
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
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		viewportOutputRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]
