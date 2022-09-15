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
		'defaultMaterial',
		'genericSurfaceMaterialVertexShaders',
		'whiteTexture2D',
		'transparentTexture2D',
		'neutralNormalTexture',
		'projectionNDCAdjustMatrix',
		'brdfLutTexture',
		'intermediateFramebuffers',
		'renderPasses',
		'depthFormat',
		'screenQuadVertexShader',
		'linearToneMappingOperator',
		'toneMapOperatorShaderDictionary',
		'reinhardToneMappingOperator',
		'exponentialToneMappingOperator',
		'filmicToneMappingOperator',
		'transparentTextureCube',
		'sideBySideStereoComposeMode',
		'leftEyeStereoComposeMode',
		'topBottomStereoComposeMode',
		'redCyanAnaglyphStereoComposeMode',
		'stereoComposeModeShaderDictionary',
		'lightStateBuffer',
		'tileLightIndexListBuffer',
		'lightGridBuffer',
		'uploadBuffer',
		'lightClusterBuffer',
		'lightGridComputationShader',
		'lightClusterListComputationShader',
		'computeScratchStorageBuffer',
		'lightClusterListBeginComputationShader',
		'shadowMapAtlasTexture',
		'shadowMapAtlasTextureDepthStencilView',
		'shadowMapAtlasFramebuffer',
		'shadowMapRenderPass',
		'emptyLightingStateBinding',
		'genericDepthOnlySurfaceFragmentShader',
		'shadowMapAtlasTextureSamplingView',
		'metallicRoughnessOpaqueFragmentShader',
		'metallicRoughnessTranslucentFragmentShader',
		'duplicatedMetallicRoughnessLiquidOpaqueFragmentShader',
		'duplicatedMetallicRoughnessLiquidTranslucentFragmentShader',
		'unlitOpaqueFragmentShader',
		'unlitTranslucentFragmentShader',
		'environmentMapOpaqueFragmentShader',
		'environmentMapTranslucentFragmentShader',
		'metallicRoughnessDepthOnlyFragmentShader',
		'unlitDepthOnlyFragmentShader',
		'duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShader',
		'environmentMapDepthOnlyFragmentShader',
		'depthTypelessFormat',
		'depthSampledFormat',
		'staticReflectionComputationFragmentShader',
		'screenSpaceReflectionComputationFragmentShader',
		'reflectionRenderPass',
		'opaqueReflectionCombinationFragmentShader',
		'screenSpaceAmbientOcclusionComputationFragmentShader',
		'screenSpaceAmbientOcclusionRenderPass',
		'shadowMapAtlasAllocator',
		'clearReverseDepthFragmentShader',
		'blurHorizontalPassFragmentShader',
		'blurVerticalPassFragmentShader',
		'downsampleFragmentShader',
		'cubeMapFaceRotationMatricesShaderSource',
		'bloomSelectionFragmentShader'
	],
	#classVars : [
		'AccessorTypeIntoTextureFormatMap',
		'ShadowMapAtlasExtent',
		'TextureFormatMap',
		'TextureMainUsageModeMap',
		'TextureTypeMap',
		'TextureUsageModesMap',
		'UploadBufferCapacity'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Resources'
}

{ #category : #'instance creation' }
WDAGPUSceneRendererResourceCache class >> for: aDevice [
	^ self for: aDevice withTextureUploader: (AGPUTextureUploader for: aDevice)
]

{ #category : #'instance creation' }
WDAGPUSceneRendererResourceCache class >> for: device withTextureUploader: textureUploader [
	^ self basicNew initializeWithDevice: device withTextureUploader: textureUploader
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache class >> initialize [
	ShadowMapAtlasExtent := 4192@4192.
	
	TextureFormatMap := Dictionary newFromPairs: {
		WDTextureFormatUnknown uniqueInstance . AGPU_TEXTURE_FORMAT_UNKNOWN.
		WDTextureFormatR8G8B8A8UNorm uniqueInstance . AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM.
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

		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt8ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R8G8B8A8_UINT.
		{ true . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt8ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM.

		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt8ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R8G8B8A8_SINT.
		{ true . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt8ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R8G8B8A8_SNORM.

		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorUInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16_UINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16B16A16_UINT.
		{ true . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorUInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16_UNORM.
		{ true . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16B16A16_UNORM.

		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16_SINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16B16A16_SINT.
		{ true . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16_SNORM.
		{ true . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt16ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R16G16B16A16_SNORM.

		{ false . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_UINT.
		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_UINT.
		{ false . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_UINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorUInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_UINT.

		{ false . WDBinaryBufferAccessorScalarType uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32_SINT.
		{ false . WDBinaryBufferAccessorVector2Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32_SINT.
		{ false . WDBinaryBufferAccessorVector3Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32_SINT.
		{ false . WDBinaryBufferAccessorVector4Type uniqueInstance . WDBinaryBufferAccessorInt32ComponentType uniqueInstance} . AGPU_TEXTURE_FORMAT_R32G32B32A32_SINT.
	}.
	
	UploadBufferCapacity := 2*1024*1024.
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache class >> shadowMapAtlasExtent [
	^ ShadowMapAtlasExtent
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> bloomRenderPass [
	^ self reflectionRenderPass
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> bloomSelectionFragmentShader [
	^ bloomSelectionFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> bloomSelectionFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , '
#line 6

layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D ColorBuffer;

void main()
{
	vec3 color = textureLod(sampler2D(ColorBuffer, ScreenTextureSampler), inTexcoord, 0.0).rgb;
	// Relative luminance: https://en.wikipedia.org/wiki/Relative_luminance
	float relativeLuminance = dot(color.rgb, vec3(0.2126 , 0.7152, 0.0722));
	if(relativeLuminance >= CameraState.bloomThreshold)
		FragmentOutputColor = vec4(color*CameraState.bloomStrength, 0.0);
	else
		FragmentOutputColor = vec4(0.0);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> blurHorizontalPassFragmentShader [
	^ blurHorizontalPassFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> blurHorizontalPassFragmentShaderSource [
	^ '
#version 450
#extension GL_EXT_samplerless_texture_functions : require
' , self samplerStateSource, '
#line 6
layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D SourceTexture;

void main()
{
	vec2 filterScale = 1.5 / vec2(textureSize(SourceTexture, 0));
	
	FragmentOutputColor = (
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(-2.0, 0.0)*filterScale, 0.0) +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(-1.0, 0.0)*filterScale, 0.0)*4.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord, 0.0)*6.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(1.0, 0.0)*filterScale, 0.0)*4.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(2.0, 0.0)*filterScale, 0.0)
	)*0.0625;
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> blurVerticalPassFragmentShader [
	^ blurVerticalPassFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> blurVerticalPassFragmentShaderSource [
	^ '
#version 450
#extension GL_EXT_samplerless_texture_functions : require
' , self samplerStateSource, '
#line 6
layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D SourceTexture;

void main()
{
	vec2 filterScale = 1.5 / vec2(textureSize(SourceTexture, 0));
	
	FragmentOutputColor = (
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(0.0, -2.0)*filterScale, 0.0) +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(0.0, -1.0)*filterScale, 0.0)*4.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord, 0.0)*6.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(0.0, 1.0)*filterScale, 0.0)*4.0 +
		textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord + vec2(0.0, 2.0)*filterScale, 0.0)
	)*0.0625;
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> brdfLutTexture [
	^ brdfLutTexture
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> buildRendererComputePipelineWithShaderSource: shaderSource [
	| shader |
	shader := self compileShader: shaderSource type: AGPU_COMPUTE_SHADER.
	^ device createComputePipelineBuilder
		setShaderSignature: rendererShaderSignature handle;
		attachShader: shader;
		build
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> cameraStateBlockSource [
	^ '
layout(set=1, binding=0, std140) uniform CameraStateBlock	
{
	mat4 transformationMatrix;
	mat4 inverseTransformationMatrix;

	mat4 projectionMatrix;
	mat4 inverseProjectionMatrix;

	float currentTime;
	float exposure;
	float bloomThreshold;
	float bloomStrength;

	float nearDistance;
	float farDistance;
	
	vec2 framebufferExtent;
	vec2 framebufferReciprocalExtent;
	
	vec2 lightGridDepthSliceScaleOffset;
	bool hasTopLeftNDCOrigin;
	bool hasBottomLeftTextureCoordinates;

	uvec3 lightGridExtent;
	bool hasReverseDepth;

} CameraState;
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> clearReverseDepthFragmentShader [
	^ clearReverseDepthFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> clearReverseDepthFragmentShaderSource [
	^ '
#version 450

void main()
{ 
	gl_FragDepth = 0.0;
}
'

]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> compileShader: sourceText type: shaderType [
	| shaderCompiler convertedSourceText |
	shaderCompiler := device createOfflineShaderCompiler.
	convertedSourceText := sourceText withUnixLineEndings.
^ [
		shaderCompiler
			setShaderSource: AGPU_SHADER_LANGUAGE_VGLSL stage: shaderType sourceText: convertedSourceText sourceTextLength: convertedSourceText size;
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
				Transcript show: 'Shader compilation error'; cr; show: compilationError.
				self error: compilationError
			] ifFalse: [
				e pass
			]
		]
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> computeScratchStorageBuffer [
	^ computeScratchStorageBuffer
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

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createShadowMapTextureWithExtent: extent clearDepth: clearDepth [
	| result |
	result := device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_R32_TYPELESS;
			usage_modes: (AGPU_TEXTURE_USAGE_SAMPLED bitOr: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT);
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: 1;
			clear_value: (AGPUTextureClearValue new
				depth_stencil: (AGPUDepthStencilValue new
					depth: clearDepth;
					yourself);
				yourself);
			yourself).
	^ result
]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createStorageBufferFor: elementWriter capacity: capacity usageModes: usageModes [
	^ self createStorageBufferForElementSize: elementWriter uniqueInstance instanceSize capacity: capacity usageModes: usageModes
]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createStorageBufferForElementSize: elementSize capacity: capacity usageModes: usageModes [
	^ self createStorageBufferWithSize: elementSize*capacity usageModes: usageModes
]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createStorageBufferWithSize: size usageModes: usageModes [
	^ device createBuffer: (AGPUBufferDescription new
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		main_usage_mode: AGPU_STORAGE_BUFFER;
		usage_modes: (AGPU_STORAGE_BUFFER bitOr: usageModes);
		size: size;
		yourself) initial_data: nil
]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createTexture2DWithSingleColor: colorData [
	| result |
	result := device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: 1;
			height: 1;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
			usage_modes: (AGPU_TEXTURE_USAGE_SAMPLED bitOr: AGPU_TEXTURE_USAGE_COPY_DESTINATION);
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: 1;
			yourself).
	result uploadTextureData: 0 arrayIndex: 0 pitch: 4 slicePitch: 4 data: colorData.
	^ result
]

{ #category : #private }
WDAGPUSceneRendererResourceCache >> createTextureCubeWithSingleColor: colorData [
	| result |
	result := device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_CUBE;
			width: 1;
			height: 1;
			depth: 1;
			layers: 6;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
			usage_modes: (AGPU_TEXTURE_USAGE_SAMPLED bitOr: AGPU_TEXTURE_USAGE_COPY_DESTINATION);
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: 1;
			yourself).
	0 to: 5 do: [ :i |
		result uploadTextureData: 0 arrayIndex: i pitch: 4 slicePitch: 4 data: colorData.
	].
	^ result
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> cubeMapFaceRotationMatricesShaderSource [
	^ cubeMapFaceRotationMatricesShaderSource ifNil: [cubeMapFaceRotationMatricesShaderSource := 		ByteString streamContents: [ :out |
			out nextPutAll: 'const mat3[6] CubeMapFaceRotations = mat3[6]('; cr.
			Matrix3x3 cubeMapFaceRotations doWithIndex: [ :each :index|
				out tab; nextPutAll: 'mat3('; cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3}),' format: {each firstColumn x. each firstColumn y . each firstColumn z}); cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3}),' format: {each secondColumn x. each secondColumn y . each secondColumn z}); cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3})' format: {each thirdColumn x. each thirdColumn y . each thirdColumn z}); cr.
				out tab; nextPutAll: (index = 6 ifTrue: [')'] ifFalse: ['),']); cr.
			].
			out nextPutAll: ');'; cr.
			
			out nextPutAll: 'const mat3[6] CubeMapInverseFaceRotations = mat3[6]('; cr.
			Matrix3x3 cubeMapFaceRotations doWithIndex: [ :each :index|
				out tab; nextPutAll: 'mat3('; cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3}),' format: {each firstRow x. each firstRow y . each firstRow z}); cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3}),' format: {each secondRow x. each secondRow y . each secondRow z}); cr.
				out tab; tab; nextPutAll: ('vec3({1}, {2}, {3})' format: {each thirdRow x. each thirdRow y . each thirdRow z}); cr.
				out tab; nextPutAll: (index = 6 ifTrue: [')'] ifFalse: ['),']); cr.
			].
			out nextPutAll: ');'; cr.
		]
]
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> defaultMaterial [
	^ defaultMaterial
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> depthFormat [
	^ depthFormat
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> depthOnlyRenderPassWithSampleCount: sampleCount initialDepth: initialDepth [
	^ renderPasses at: {#depthOnlyRenderPassWithSampleCount . sampleCount . initialDepth} ifAbsentPut: [
		| depthStencilAttachment |
		[
			| renderpassDescription |
			depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
				format: depthFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: (AGPUDepthStencilValue new
					depth: initialDepth;
					yourself);
				yourself.
				
			renderpassDescription := AGPURenderpassDescription new.
			renderpassDescription
				depth_stencil_attachment: depthStencilAttachment.
			device createRenderPass: renderpassDescription
		] ensure: [
			depthStencilAttachment ifNotNil: [depthStencilAttachment free].
		]
	].

]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> depthOnlyVertexAttributesForMask [
	^ ((1 bitShift: 0)
		bitOr: (1 bitShift: 5))
		bitOr: (1 bitShift: 6)
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> depthSampledFormat [
	^ depthSampledFormat
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> depthTypelessFormat [
	^ depthTypelessFormat
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> device [
	^ device
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> downsampleFragmentShader [
	^ downsampleFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> downsampleFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, '
#line 6
layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D SourceTexture;

void main()
{
	FragmentOutputColor = textureLod(sampler2D(SourceTexture, ScreenTextureSampler), inTexcoord, 0.0);
}
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShader [
	^ duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self cameraStateBlockSource, self duplicatedMetallicRoughnessLiquidMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;

	vec2 texcoord1 = StageInput.texcoord0;
	texcoord1 = texcoord1*MaterialState.duplicatedTexcoordScale + MaterialState.duplicatedTexcoordOffset + MaterialState.duplicatedTexcoordOffsetVelocity*CameraState.currentTime;
	
	vec4 baseColor = StageInput.color * MaterialState.baseColorFactor *
		mix(texture(sampler2D(BaseColorTexture, TextureSampler), texcoord0),
			texture(sampler2D(BaseColorTexture, TextureSampler), texcoord1),
			MaterialState.mixAlpha);
	if(baseColor.a < MaterialState.alphaCutoff)
		discard;
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidFragmentShaderSourceForOpaquePass: isOpaquePass [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, (self renderFragmentShaderOutputsForOpaquePass: isOpaquePass), self cameraStateBlockSource, self metallicRoughnessLightingModel, self duplicatedMetallicRoughnessLiquidMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;

	vec2 texcoord1 = StageInput.texcoord0;
	texcoord1 = texcoord1*MaterialState.duplicatedTexcoordScale + MaterialState.duplicatedTexcoordOffset + MaterialState.duplicatedTexcoordOffsetVelocity*CameraState.currentTime;
	
	SurfaceLightingParameters lightingParameters;
		
	lightingParameters.baseColor = StageInput.color * MaterialState.baseColorFactor *
		mix(texture(sampler2D(BaseColorTexture, TextureSampler), texcoord0),
			texture(sampler2D(BaseColorTexture, TextureSampler), texcoord1),
			MaterialState.mixAlpha);
	if(lightingParameters.baseColor.a < MaterialState.alphaCutoff)
		discard;

	lightingParameters.emissiveFactor = StageInput.color.rgb * MaterialState.emissiveFactor.rgb * texture(sampler2D(EmissiveTexture, TextureSampler), texcoord0).rgb;
	vec3 tangentSpaceN = mix(
		texture(sampler2D(NormalTexture, TextureSampler), texcoord0),
		texture(sampler2D(NormalTexture, TextureSampler), texcoord1),
		MaterialState.mixAlpha).rgb*2.0 - 1.0;
		
	vec3 surfaceTangent = normalize(StageInput.tangent4.xyz);
	vec3 surfaceNormal = normalize(StageInput.normal);
	vec3 surfaceBitangent = cross(surfaceNormal, surfaceTangent)*StageInput.tangent4.w;
	mat3 TBN = mat3(surfaceTangent, surfaceBitangent, surfaceNormal);
	lightingParameters.N = normalize(TBN * tangentSpaceN);
	lightingParameters.P = StageInput.viewPosition;
	lightingParameters.V = normalize(-StageInput.viewPosition);
	lightingParameters.worldP = StageInput.worldPosition;
	lightingParameters.worldSurfaceN = normalize(StageInput.worldNormal);

	lightingParameters.occlusionFactor = MaterialState.occlusionFactor *
		mix(texture(sampler2D(OcclusionTexture, TextureSampler), texcoord0).r,
			texture(sampler2D(OcclusionTexture, TextureSampler), texcoord1).r,
			MaterialState.mixAlpha);

	vec2 roughnessMetallicFactor = vec2(MaterialState.roughnessFactor, MaterialState.metallicFactor) *
		mix(texture(sampler2D(MetallicRoughnessTexture, TextureSampler), texcoord0).gb,
			texture(sampler2D(MetallicRoughnessTexture, TextureSampler), texcoord1).gb,
			MaterialState.mixAlpha);
	lightingParameters.roughnessFactor = roughnessMetallicFactor.x;
	lightingParameters.metallicFactor = roughnessMetallicFactor.y;
	
	DefineRenderPassDummyOutputs();
	FragmentOutputColor = performLightingModelComputation(lightingParameters, FragmentOutputNormal, FragmentOutputSpecularity);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidMaterialStateSource [
	^ '
layout(set=4, binding=0, std140) uniform MaterialStateBlock	
{
	int doubleSided;
	float alphaCutoff;

	vec4 baseColorFactor;
	vec3 emissiveFactor;

	float occlusionFactor;
	float roughnessFactor;
	float metallicFactor;
		
	vec2 texcoordOffset;
	vec2 texcoordScale;
	vec2 texcoordOffsetVelocity;

	vec2 duplicatedTexcoordOffset;
	vec2 duplicatedTexcoordScale;
	vec2 duplicatedTexcoordOffsetVelocity;

	float mixAlpha;
} MaterialState;

layout(set=4, binding=1) uniform texture2D BaseColorTexture;
layout(set=4, binding=2) uniform texture2D EmissiveTexture;
layout(set=4, binding=3) uniform texture2D NormalTexture;
layout(set=4, binding=4) uniform texture2D OcclusionTexture;
layout(set=4, binding=5) uniform texture2D MetallicRoughnessTexture;
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidOpaqueFragmentShader [
	^ duplicatedMetallicRoughnessLiquidOpaqueFragmentShader
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> duplicatedMetallicRoughnessLiquidTranslucentFragmentShader [
	^ duplicatedMetallicRoughnessLiquidTranslucentFragmentShader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> emptyLightingStateBinding [
	^ emptyLightingStateBinding
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapDepthOnlyFragmentShader [
	^ environmentMapDepthOnlyFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapDepthOnlyFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , self genericSurfaceMaterialFragmentShaderInputs, self environmentMapMaterialStateSource , '
#line 6

void main()
{ 
	vec4 color = StageInput.color * MaterialState.colorFactor * texture(samplerCube(ColorTexture, TextureSampler), StageInput.worldPosition - CameraState.transformationMatrix[3].xyz);
	if(color.a < MaterialState.alphaCutoff)
		discard;
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapFragmentShaderSourceForOpaquePass: isOpaquePass [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , self genericSurfaceMaterialFragmentShaderInputs, (self renderFragmentShaderOutputsForOpaquePass: isOpaquePass), self environmentMapMaterialStateSource , '
#line 6

void main()
{ 
	vec4 color = StageInput.color * MaterialState.colorFactor * texture(samplerCube(ColorTexture, TextureSampler), StageInput.worldPosition - CameraState.transformationMatrix[3].xyz);
	if(color.a < MaterialState.alphaCutoff)
		discard;
		
	DefineRenderPassDummyOutputs();
	FragmentOutputColor = color;
	FragmentOutputNormal = vec2(0.0);
	FragmentOutputSpecularity = vec4(0.0);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapMaterialStateSource [
	^ '
layout(set=4, binding=0, std140) uniform MaterialStateBlock
{
	int doubleSided;
	float alphaCutoff;
	vec4 colorFactor;
} MaterialState;

layout(set=4, binding=1) uniform textureCube ColorTexture;
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapOpaqueFragmentShader [
	^ environmentMapOpaqueFragmentShader
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> environmentMapTranslucentFragmentShader [
	^ environmentMapTranslucentFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> exponentialToneMappingOperatorShaderSource [
	^ '
#version 450
' , self samplerStateSource, self toneMappingOperatorIOSource , self cameraStateBlockSource , '
#line 6


void main()
{
	vec4 hdrTexel = textureLod(sampler2D(HDRColorBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	vec3 hdrColor = hdrTexel.rgb * CameraState.exposure;
	vec3 ldrColor = 1.0 - exp(-hdrColor);
	FragmentOutputColor = vec4(ldrColor, hdrTexel.a);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> filmicToneMappingOperatorShaderSource [
	^ '
#version 450
' , self samplerStateSource, self toneMappingOperatorIOSource , self cameraStateBlockSource , '
#line 6

vec3 filmicCurve(vec3 x)
{
	// Filmic tone mapping curve from: https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
	float a = 2.51;
	float b = 0.03;
	float c = 2.43;
	float d = 0.59;
	float e = 0.14;
	return clamp((x*(a*x+b))/(x*(c*x+d)+e), 0.0, 1.0);
}

void main()
{
	vec4 hdrTexel = textureLod(sampler2D(HDRColorBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	vec3 hdrColor = hdrTexel.rgb * CameraState.exposure;
	vec3 ldrColor = filmicCurve(hdrColor);
	FragmentOutputColor = vec4(ldrColor, hdrTexel.a);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> genericDepthOnlySurfaceFragmentShader [
	^ genericDepthOnlySurfaceFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> genericDepthOnlySurfaceFragmentShaderSource [
	^ '
#version 450
#line 6

void main()
{
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> genericSurfaceMaterialFragmentShaderInputs [
	^ '
layout(location=0) in StageInputBlock
{ 
	vec4 color;
	vec2 texcoord0;
	vec2 texcoord1;
	vec3 normal;
	vec4 tangent4;
	vec3 worldNormal;
	vec3 worldPosition;
	vec3 viewPosition;
} StageInput;

'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> genericSurfaceMaterialVertexShaderSourceWithMask: mask [
	^ '
#version 450
' ,
(self vertexAttributesForMask: mask ),
self cameraStateBlockSource ,
self objectStateBlockSource ,'
#line 9

layout(location=0) out StageOutputBlock
{ 
	vec4 color;
	vec2 texcoord0;
	vec2 texcoord1;
	vec3 normal;
	vec4 tangent4;
	vec3 worldNormal;
	vec3 worldPosition;
	vec3 viewPosition;
} StageOutput;

vec3 transformNormalToWorld(vec3 normal)
{ 
	return normal *
		mat3(ObjectState.inverseTransformationMatrix[0].xyz,
		ObjectState.inverseTransformationMatrix[1].xyz,
		ObjectState.inverseTransformationMatrix[2].xyz);
}

vec3 transformNormalWorldToView(vec3 normal)
{ 
	return normal *
		mat3(CameraState.transformationMatrix[0].xyz,
		CameraState.transformationMatrix[1].xyz,
		CameraState.transformationMatrix[2].xyz);
}

vec3 transformNormalToView(vec3 normal)
{ 
	return transformNormalWorldToView(transformNormalToWorld(normal));
}

void main()
{
#ifdef HAS_PER_VERTEX_COLOR
	StageOutput.color = inColor;
#else
	StageOutput.color = vec4(1.0);
#endif

#ifdef HAS_PER_VERTEX_TEXCOORD0
	StageOutput.texcoord0 = inTexcoord0;
#else
	StageOutput.texcoord0 = vec2(0.0);
#endif

#ifdef HAS_PER_VERTEX_TEXCOORD1
	StageOutput.texcoord1 = inTexcoord1;
#else
	StageOutput.texcoord1 = vec2(0.0);
#endif

#ifdef HAS_PER_VERTEX_NORMAL
	StageOutput.worldNormal = transformNormalToWorld(inNormal);
	StageOutput.normal = transformNormalWorldToView(StageOutput.worldNormal);
#	ifdef HAS_PER_VERTEX_TANGENT4
	StageOutput.tangent4 = vec4(transformNormalToView(inTangent4.xyz), inTangent4.w);
#	else
	vec3 upVector = abs(StageOutput.normal.y) > 0.9 ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 1.0, 0.0);
	StageOutput.tangent4 = vec4(cross(upVector, StageOutput.normal), 1.0);
#	endif
#else
	StageOutput.worldNormal = vec3(0.0, 0.0, 1.0);
	StageOutput.normal = vec3(0.0, 0.0, 1.0);
	StageOutput.tangent4 = vec4(1.0, 0.0, 0.0, 1.0);
#endif

	vec4 worldPosition = ObjectState.transformationMatrix * vec4(inPosition, 1.0);
	vec4 viewPosition = CameraState.inverseTransformationMatrix * worldPosition;
	StageOutput.worldPosition = worldPosition.xyz;
	StageOutput.viewPosition = viewPosition.xyz;
	gl_Position = CameraState.projectionMatrix * viewPosition;
}
'
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> genericSurfaceMaterialVertexShaderWithLocationMask: mask [
	^ genericSurfaceMaterialVertexShaders at: mask ifAbsentPut: [
		self compileShader: (self genericSurfaceMaterialVertexShaderSourceWithMask: mask) type: AGPU_VERTEX_SHADER
	]
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> hdrBlurRenderPass [
	^ self reflectionRenderPass
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> hdrOpaqueRenderPassWithSampleCount: sampleCount [
	^ renderPasses at: {#hdrOpaqueRenderPass . sampleCount} ifAbsentPut: [
		| depthStencilAttachment colorAttachmentDescriptionsPointer |
		[
			| colorAttachmentDescriptions allAttachmentsDescriptionsData renderpassDescription |
			colorAttachmentDescriptions := {
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself.
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R16G16_SNORM;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself.
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself
			}.
				
			depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
				format: depthFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself.
				
			allAttachmentsDescriptionsData := ByteArray streamContents: [ :out |
				colorAttachmentDescriptions do: [ :each |
					out nextPutAll: each getHandle
				]
			].
		
			colorAttachmentDescriptionsPointer := ExternalAddress allocate: allAttachmentsDescriptionsData size.
			colorAttachmentDescriptionsPointer replaceFrom: 1 to: allAttachmentsDescriptionsData size with: allAttachmentsDescriptionsData startingAt: 1.
				
			renderpassDescription := AGPURenderpassDescription new.
			renderpassDescription
				color_attachment_count: 3;
				color_attachments: (AGPURenderpassColorAttachmentDescription fromHandle: colorAttachmentDescriptionsPointer);
				depth_stencil_attachment: depthStencilAttachment.
			device createRenderPass: renderpassDescription
		] ensure: [
			colorAttachmentDescriptionsPointer ifNotNil: [ colorAttachmentDescriptionsPointer free ].
			depthStencilAttachment ifNotNil: [depthStencilAttachment free].
		]
	].

]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> hdrOpaqueRenderPassWithSampleCount: sampleCount initialDepth: initialDepth [
	^ renderPasses at: {#hdrOpaqueRenderPass . sampleCount . initialDepth} ifAbsentPut: [
		| depthStencilAttachment colorAttachmentDescriptionsPointer |
		[
			| colorAttachmentDescriptions allAttachmentsDescriptionsData renderpassDescription |
			colorAttachmentDescriptions := {
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself.
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R16G16_SNORM;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself.
			AGPURenderpassColorAttachmentDescription new
				format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0;
				yourself
			}.
				
			depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
				format: depthFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: (AGPUDepthStencilValue new
					depth: initialDepth;
					yourself);
				yourself.
				
			allAttachmentsDescriptionsData := ByteArray streamContents: [ :out |
				colorAttachmentDescriptions do: [ :each |
					out nextPutAll: each getHandle
				]
			].
		
			colorAttachmentDescriptionsPointer := ExternalAddress allocate: allAttachmentsDescriptionsData size.
			colorAttachmentDescriptionsPointer replaceFrom: 1 to: allAttachmentsDescriptionsData size with: allAttachmentsDescriptionsData startingAt: 1.
				
			renderpassDescription := AGPURenderpassDescription new.
			renderpassDescription
				color_attachment_count: 3;
				color_attachments: (AGPURenderpassColorAttachmentDescription fromHandle: colorAttachmentDescriptionsPointer);
				depth_stencil_attachment: depthStencilAttachment.
			device createRenderPass: renderpassDescription
		] ensure: [
			colorAttachmentDescriptionsPointer ifNotNil: [ colorAttachmentDescriptionsPointer free ].
			depthStencilAttachment ifNotNil: [depthStencilAttachment free].
		]
	].

]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> hdrTranslucentContinueRenderPassWithSampleCount: sampleCount [
	^ renderPasses at: {#hdrTranslucentContinueRenderPass . sampleCount} ifAbsentPut: [
		| colorAttachment depthStencilAttachment |
		[
			| renderpassDescription |
			colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
			colorAttachment
				format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0.
			depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
				format: depthFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself.
			renderpassDescription := AGPURenderpassDescription new.
			renderpassDescription
				color_attachment_count: 1;
				color_attachments: colorAttachment;
				depth_stencil_attachment: depthStencilAttachment.
			device createRenderPass: renderpassDescription
		] ensure: [
			colorAttachment ifNotNil: [colorAttachment free].
			depthStencilAttachment ifNotNil: [colorAttachment free].
		]
	].

]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> hdrTranslucentRenderPassWithSampleCount: sampleCount [
	^ renderPasses at: {#hdrTranslucentRenderPass . sampleCount} ifAbsentPut: [
		| colorAttachment depthStencilAttachment |
		[
			| renderpassDescription |
			colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
			colorAttachment
				format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
				begin_action: AGPU_ATTACHMENT_DISCARD;
				end_action: AGPU_ATTACHMENT_KEEP;
				sample_count: sampleCount;
				clear_value: AGPUColor4f new;
				sample_quality: 0.
			depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
				format: depthFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself.
			renderpassDescription := AGPURenderpassDescription new.
			renderpassDescription
				color_attachment_count: 1;
				color_attachments: colorAttachment;
				depth_stencil_attachment: depthStencilAttachment.
			device createRenderPass: renderpassDescription
		] ensure: [
			colorAttachment ifNotNil: [colorAttachment free].
			depthStencilAttachment ifNotNil: [colorAttachment free].
		]
	].

]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> initializeWithDevice: aDevice withTextureUploader: aTextureUploader [
	| shadowMapAtlasTextureDepthStencilViewDescription shadowMapAtlasTextureSamplingViewDescription |
	device := aDevice.
	textureUploader := aTextureUploader.
	textures := WeakKeyDictionary new.
	framebuffers := WeakKeyDictionary new.
	intermediateFramebuffers := WeakKeyDictionary new.
	buffers := WeakKeyDictionary new.
	vertexBindings := WeakKeyDictionary new.
	rendererShaderSignature := WDAGPURendererShaderSignature for: device.
	vertexLayouts := Dictionary new.
	renderPasses := Dictionary new.
	
	uploadBuffer := WDAGPUShaderStackAllocator for: device capacity: UploadBufferCapacity.

	computeScratchStorageBuffer := self createStorageBufferWithSize: 4096 usageModes: 0.
	lightClusterBuffer := self createStorageBufferForElementSize: 32 capacity: WDAGPUSceneRenderer lightGridCellCount usageModes: 0.
	lightStateBuffer := self createStorageBufferFor: WDAGPULightStateUniformBufferWriter capacity: WDAGPUSceneRenderer maxLightCapacity + 1 usageModes: AGPU_COPY_DESTINATION_BUFFER.
	tileLightIndexListBuffer := self createStorageBufferForElementSize: 4 capacity: WDAGPUSceneRenderer maxClusterLightCapacity * WDAGPUSceneRenderer lightGridCellCount usageModes: 0.
	lightGridBuffer := self createStorageBufferForElementSize: 8 capacity: WDAGPUSceneRenderer lightGridCellCount usageModes: 0.
	
	whiteTexture2D := self createTexture2DWithSingleColor: #[255 255 255 255].
	transparentTexture2D := self createTexture2DWithSingleColor: #[0 0 0 0].
	neutralNormalTexture := self createTexture2DWithSingleColor: #[128 128 255 255].
	transparentTextureCube := self createTextureCubeWithSingleColor: #[0 0 0 0].
	
	shadowMapAtlasTexture := self createShadowMapTextureWithExtent: ShadowMapAtlasExtent clearDepth: 0.0.
	shadowMapAtlasTextureSamplingViewDescription := AGPUTextureViewDescription new.
	shadowMapAtlasTexture getFullViewDescription: shadowMapAtlasTextureSamplingViewDescription.
	shadowMapAtlasTextureSamplingViewDescription
		format: AGPU_TEXTURE_FORMAT_R32_FLOAT;
		usage_mode: AGPU_TEXTURE_USAGE_SAMPLED.
	shadowMapAtlasTextureSamplingView := shadowMapAtlasTexture createView: shadowMapAtlasTextureSamplingViewDescription.
	
	shadowMapAtlasTextureDepthStencilViewDescription := AGPUTextureViewDescription new.
	shadowMapAtlasTexture getFullViewDescription: shadowMapAtlasTextureDepthStencilViewDescription.
	shadowMapAtlasTextureDepthStencilViewDescription
		format: AGPU_TEXTURE_FORMAT_D32_FLOAT;
		usage_mode: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT.

	shadowMapAtlasTextureDepthStencilView := shadowMapAtlasTexture createView: shadowMapAtlasTextureDepthStencilViewDescription.
	shadowMapAtlasFramebuffer := device createFrameBuffer: ShadowMapAtlasExtent x height: ShadowMapAtlasExtent y colorCount: 0 colorViews: nil depthStencilView: shadowMapAtlasTextureDepthStencilView.
	
	shadowMapAtlasAllocator := WDAGPUShadowMapTextureAtlasAllocator forAtlasWithExtent: ShadowMapAtlasExtent.
	
	genericSurfaceMaterialVertexShaders := Dictionary new.
	genericDepthOnlySurfaceFragmentShader := self compileShader: self genericDepthOnlySurfaceFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	
	metallicRoughnessOpaqueFragmentShader := self compileShader: (self metallicRoughnessFragmentShaderSourceForOpaquePass: true) type: AGPU_FRAGMENT_SHADER.
	metallicRoughnessTranslucentFragmentShader := self compileShader: (self metallicRoughnessFragmentShaderSourceForOpaquePass: false) type: AGPU_FRAGMENT_SHADER.
	metallicRoughnessDepthOnlyFragmentShader := self compileShader: self metallicRoughnessDepthOnlyFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	unlitOpaqueFragmentShader := self compileShader: (self unlitFragmentShaderSourceForOpaquePass: true) type: AGPU_FRAGMENT_SHADER.
	unlitTranslucentFragmentShader := self compileShader: (self unlitFragmentShaderSourceForOpaquePass: false) type: AGPU_FRAGMENT_SHADER.
	unlitDepthOnlyFragmentShader := self compileShader: self unlitDepthOnlyFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	environmentMapOpaqueFragmentShader := self compileShader: (self environmentMapFragmentShaderSourceForOpaquePass: true) type: AGPU_FRAGMENT_SHADER.
	environmentMapTranslucentFragmentShader := self compileShader: (self environmentMapFragmentShaderSourceForOpaquePass: false) type: AGPU_FRAGMENT_SHADER.
	environmentMapDepthOnlyFragmentShader := self compileShader: self environmentMapDepthOnlyFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	duplicatedMetallicRoughnessLiquidOpaqueFragmentShader := self compileShader: (self duplicatedMetallicRoughnessLiquidFragmentShaderSourceForOpaquePass: true) type: AGPU_FRAGMENT_SHADER.
	duplicatedMetallicRoughnessLiquidTranslucentFragmentShader := self compileShader: (self duplicatedMetallicRoughnessLiquidFragmentShaderSourceForOpaquePass: false) type: AGPU_FRAGMENT_SHADER.
	duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShader := self compileShader: self duplicatedMetallicRoughnessLiquidDepthOnlyFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	screenQuadVertexShader := textureUploader utilityResourceCache screenQuadVertexShader.
	defaultMaterial := WDMetallicRoughnessMaterial default.
	projectionNDCAdjustMatrix :=
		device hasTopLeftNdcOrigin ~~ 0
			ifTrue: [ Matrix4x4 projectionInvertYMatrix ]
			ifFalse: [ Matrix4x4 identity ].
	brdfLutTexture := textureUploader createAndComputeBRDFLut.
	depthFormat := AGPU_TEXTURE_FORMAT_D32_FLOAT.
	depthTypelessFormat := AGPU_TEXTURE_FORMAT_R32_TYPELESS.
	depthSampledFormat := AGPU_TEXTURE_FORMAT_R32_FLOAT.
	
	screenSpaceAmbientOcclusionComputationFragmentShader := self compileShader: self screenSpaceAmbientOcclusionComputationFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	staticReflectionComputationFragmentShader := self compileShader: self staticReflectionComputationFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	screenSpaceReflectionComputationFragmentShader := self compileShader: self screenSpaceReflectionComputationFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	opaqueReflectionCombinationFragmentShader := self compileShader: self opaqueReflectionCombinationFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	
	clearReverseDepthFragmentShader := self compileShader: self clearReverseDepthFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	downsampleFragmentShader := self compileShader: self downsampleFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	blurHorizontalPassFragmentShader := self compileShader: self blurHorizontalPassFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	blurVerticalPassFragmentShader := self compileShader: self blurVerticalPassFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	bloomSelectionFragmentShader := self compileShader: self bloomSelectionFragmentShaderSource type: AGPU_FRAGMENT_SHADER.

	linearToneMappingOperator := self compileShader: self linearToneMappingOperatorShaderSource type: AGPU_FRAGMENT_SHADER.
	reinhardToneMappingOperator := self compileShader: self reinhardToneMappingOperatorShaderSource type: AGPU_FRAGMENT_SHADER.
	exponentialToneMappingOperator := self compileShader: self exponentialToneMappingOperatorShaderSource type: AGPU_FRAGMENT_SHADER.
	filmicToneMappingOperator := self compileShader: self filmicToneMappingOperatorShaderSource type: AGPU_FRAGMENT_SHADER.
	
	toneMapOperatorShaderDictionary := Dictionary newFromPairs: {
		WDLinearToneMappingOperator asToneMappingOperator . linearToneMappingOperator.
		WDReinhardToneMappingOperator asToneMappingOperator . reinhardToneMappingOperator.
		WDExponentialToneMappingOperator asToneMappingOperator . exponentialToneMappingOperator.
		WDFilmicToneMappingOperator asToneMappingOperator . filmicToneMappingOperator.
	}.

	leftEyeStereoComposeMode := self compileShader: self leftEyeStereoComposeShaderSource type: AGPU_FRAGMENT_SHADER.
	sideBySideStereoComposeMode := self compileShader: self sideBySideStereoComposeShaderSource type: AGPU_FRAGMENT_SHADER.
	topBottomStereoComposeMode := self compileShader: self topBottomStereoComposeShaderSource type: AGPU_FRAGMENT_SHADER.
	redCyanAnaglyphStereoComposeMode := self compileShader: self redCyanAnaglyphComposeShaderSource type: AGPU_FRAGMENT_SHADER.
	
	lightGridComputationShader := self compileShader: self lightGridComputationShaderSource type: AGPU_COMPUTE_SHADER.
	lightClusterListBeginComputationShader := self compileShader: self lightClusterListBeginComputationShaderSource type: AGPU_COMPUTE_SHADER.
	lightClusterListComputationShader := self compileShader: self lightClusterListComputationShaderSource type: AGPU_COMPUTE_SHADER.
	
	stereoComposeModeShaderDictionary := Dictionary newFromPairs: {
		WDLeftEyeStereoCompositionMode asStereoComposeMode . leftEyeStereoComposeMode.
		WDSideBySideStereoCompositionMode asStereoComposeMode . sideBySideStereoComposeMode.
		WDTopBottomStereoCompositionMode asStereoComposeMode . topBottomStereoComposeMode.
		WDRedCyanAnaglyphStereoCompositionMode asStereoComposeMode . redCyanAnaglyphStereoComposeMode.
	}.
	
	emptyLightingStateBinding := rendererShaderSignature allocateLightingState
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> leftEyeStereoComposeShaderSource [
	^ '
#version 450
' , self samplerStateSource, self stereoComposeShaderIOSource , '
#line 6

void main()
{
	FragmentOutputColor = textureLod(sampler2D(LeftEyeBuffer, ScreenTextureSampler), inTexcoord, 0.0);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightClusterBuffer [
	^ lightClusterBuffer
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightClusterListBeginComputationShader [
	^ lightClusterListBeginComputationShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> lightClusterListBeginComputationShaderSource [
	^ '
#version 450
#line 6

layout(set=1, binding=1, std430) buffer ListComputationGlobalStateBlock
{
	uint listSize;
} ListComputationGlobalState;

void main()
{
	ListComputationGlobalState.listSize = 0u;
}
'

]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightClusterListComputationShader [
	^ lightClusterListComputationShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> lightClusterListComputationShaderSource [
	"Clustered forward rendering list shader is heavily based in the one from http://www.aortiz.me/2018/12/21/CG.html by Ángel Ortiz"
	^ '
#version 450
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;
' , self cameraStateBlockSource, self lightingStateBlockSource, '
#line 6

layout(set=1, binding=1, std430) buffer ListComputationGlobalStateBlock
{
	uint listSize;
} ListComputationGlobalState;

const uint MaxNumberOfLightsPerTile = 100u;
const uint BatchSize = 64u;

shared bool[BatchSize] SharedLightIsVisible;
shared vec4[BatchSize] SharedLightPositionOrDirection;
shared float[BatchSize] SharedLightRadius;

float computeBoundingBoxPointDistance2(vec3 bboxCenter, vec3 bboxHalfExtent, vec3 sphereCenter)
{
	vec3 delta = max(abs(sphereCenter - bboxCenter) - bboxHalfExtent, 0.0);
	return dot(delta, delta);
}

bool testBoundingBoxWithSphere(vec3 bboxCenter, vec3 bboxHalfExtent, vec4 sphereCenter, float sphereRadius)
{ 
	if (sphereCenter.w == 0.0)
		return true;
	else
		return computeBoundingBoxPointDistance2(bboxCenter, bboxHalfExtent, sphereCenter.xyz) <= sphereRadius*sphereRadius;
}

void main()
{
	uvec3 gridExtent = CameraState.lightGridExtent;
	uint tileCount = gridExtent.x*gridExtent.y*gridExtent.z;
	uint tileIndex = gl_GlobalInvocationID.x;
	vec3 tileMin = tileIndex < tileCount ? LightClusters.clusters[tileIndex].min : vec3(0.0);
	vec3 tileMax = tileIndex < tileCount ? LightClusters.clusters[tileIndex].max : vec3(0.0);
	
	vec3 tileHalfExtent = (tileMax - tileMin)*0.5;
	vec3 tileCenter = tileMin + tileHalfExtent;

	uint visibleLightCount = 0;
	uint visibleLightIndices[MaxNumberOfLightsPerTile];
	
	uint lightCount = LightingState.numberOfLights;
	
	for(uint batchStartLightIndex = 0u; batchStartLightIndex < lightCount; batchStartLightIndex += BatchSize)
	{
		// Fetch the lights.
		{ 
			uint lightIndex = min(batchStartLightIndex + gl_LocalInvocationIndex, lightCount);
#define thisLight AllLight.lights[lightIndex]
			vec3 intensity = thisLight.intensity;

			SharedLightIsVisible[gl_LocalInvocationIndex] = lightIndex < lightCount
				&& thisLight.influenceRadius > 0
				&& (intensity.r > 0.0 || intensity.g > 0.0 || intensity.b > 0.0);
			SharedLightPositionOrDirection[gl_LocalInvocationIndex] = thisLight.positionOrDirection;
			SharedLightRadius[gl_LocalInvocationIndex] = thisLight.influenceRadius;
#undef thisLight
		}
		
		memoryBarrierShared();
		barrier();
		
		for(uint i = 0u; i < BatchSize; ++i)
		{
			if(visibleLightCount < MaxNumberOfLightsPerTile &&
				SharedLightIsVisible[i] &&
				tileIndex < tileCount &&
				testBoundingBoxWithSphere(tileCenter, tileHalfExtent, SharedLightPositionOrDirection[i], SharedLightRadius[i]))
			{
				uint lightIndex = batchStartLightIndex + i;
				visibleLightIndices[visibleLightCount++] = lightIndex;
			}
		}
	}
	
	barrier();

	if(tileIndex < tileCount)
	{ 
		uint destinationIndex = visibleLightCount > 0 ? atomicAdd(ListComputationGlobalState.listSize, visibleLightCount) : 0;
		for(uint i = 0u; i < visibleLightCount; ++i)
			TileLightIndices.indices[destinationIndex + i] = visibleLightIndices[i];

		LightClusterLists.lists[tileIndex] = uvec2(destinationIndex, visibleLightCount);
	}
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightGridBuffer [
	^ lightGridBuffer
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightGridComputationShader [
	^ lightGridComputationShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> lightGridComputationShaderSource [
	^ '
#version 450
layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;
' , self cameraStateBlockSource, self lightingStateBlockSource, '
#line 6

vec3 ndcToView(vec4 ndc)
{
	vec4 viewPosition4 = CameraState.inverseProjectionMatrix * ndc;
	return viewPosition4.xyz / viewPosition4.w;
}

float depthForSliceIndex(uint sliceIndex)
{ 
	return -CameraState.nearDistance*pow(CameraState.farDistance/CameraState.nearDistance, float(sliceIndex) / float(CameraState.lightGridExtent.z));
}

vec3 projectNearFrustumCornerToDepth(vec3 corner, float depth)
{
	return corner*depth/-CameraState.nearDistance;
}

void main()
{
	uvec3 gridExtent = CameraState.lightGridExtent;

	// Bounds check
	if(any(greaterThanEqual(gl_GlobalInvocationID, gridExtent)))
		return;
		
	float nearDistanceDepth = CameraState.hasReverseDepth ? 1.0 : 0.0;
		
	vec4 ndcBottomLeftCorner = vec4(vec2(gl_GlobalInvocationID.xy) / vec2(gridExtent.xy)*2.0 - 1.0, nearDistanceDepth, 1.0);
	vec4 ndcBottomRightCorner = vec4(vec2(gl_GlobalInvocationID.xy + uvec2(1u, 0u))/ vec2(gridExtent.xy)*2.0 - 1.0, nearDistanceDepth, 1.0);
	vec4 ndcTopLeftCorner = vec4(vec2(gl_GlobalInvocationID.xy + uvec2(0u, 1u))/ vec2(gridExtent.xy)*2.0 - 1.0, nearDistanceDepth, 1.0);
	vec4 ndcTopRightCorner = vec4(vec2(gl_GlobalInvocationID.xy + 1u) / vec2(gridExtent.xy)*2.0 - 1.0, nearDistanceDepth, 1.0);
	
	if(!CameraState.hasTopLeftNDCOrigin)
	{ 
		ndcBottomLeftCorner.y = -ndcBottomLeftCorner.y;
		ndcBottomRightCorner.y = -ndcBottomRightCorner.y;
		ndcTopLeftCorner.y = -ndcTopLeftCorner.y;
		ndcTopRightCorner.y = -ndcTopRightCorner.y;
	}
	
	vec3 viewBottomLeftCorner = ndcToView(ndcBottomLeftCorner);
	vec3 viewBottomRightCorner = ndcToView(ndcBottomRightCorner);
	vec3 viewTopLeftCorner = ndcToView(ndcTopLeftCorner);
	vec3 viewTopRightCorner = ndcToView(ndcTopRightCorner);
	
	float tileNearDistance = depthForSliceIndex(gl_GlobalInvocationID.z);
	float tileFarDistance = depthForSliceIndex(gl_GlobalInvocationID.z + 1u);
	
	vec3 tileNearBottomLeftCorner = projectNearFrustumCornerToDepth(viewBottomLeftCorner, tileNearDistance);
	vec3 tileNearBottomRightCorner = projectNearFrustumCornerToDepth(viewBottomRightCorner, tileNearDistance);
	vec3 tileNearTopLeftCorner = projectNearFrustumCornerToDepth(viewTopLeftCorner, tileNearDistance);
	vec3 tileNearTopRightCorner = projectNearFrustumCornerToDepth(viewTopRightCorner, tileNearDistance);

	vec3 tileFarBottomLeftCorner = projectNearFrustumCornerToDepth(viewBottomLeftCorner, tileFarDistance);
	vec3 tileFarBottomRightCorner = projectNearFrustumCornerToDepth(viewBottomRightCorner, tileFarDistance);
	vec3 tileFarTopLeftCorner = projectNearFrustumCornerToDepth(viewTopLeftCorner, tileFarDistance);
	vec3 tileFarTopRightCorner = projectNearFrustumCornerToDepth(viewTopRightCorner, tileFarDistance);

	LightCluster cluster;
	cluster.min = min(
			min(min(tileNearBottomLeftCorner, tileNearBottomRightCorner),
			min(tileNearTopLeftCorner, tileNearTopRightCorner)),

			min(min(tileFarBottomLeftCorner, tileFarBottomRightCorner),
			min(tileFarTopLeftCorner, tileFarTopRightCorner))
	);
	cluster.max = max(
			max(max(tileNearBottomLeftCorner, tileNearBottomRightCorner),
			max(tileNearTopLeftCorner, tileNearTopRightCorner)),

			max(max(tileFarBottomLeftCorner, tileFarBottomRightCorner),
			max(tileFarTopLeftCorner, tileFarTopRightCorner))
	);

	uint tileIndex = gl_GlobalInvocationID.x + gl_GlobalInvocationID.y*gridExtent.x + gl_GlobalInvocationID.z*gridExtent.x*gridExtent.y;
	LightClusters.clusters[tileIndex] = cluster;
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> lightStateBuffer [
	^ lightStateBuffer
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> lightingStateBlockSource [
	^ '
#line 4
struct LightSource
{
	vec4 positionOrDirection;

	vec3 intensity;
	float influenceRadius;

	vec3 spotDirection;
	float innerSpotCosCutoff;

	float outerSpotCosCutoff;
	bool castShadows;
	vec2 shadowMapViewportScale;
	
	vec4 shadowMapCascadeDistanceWorldTransform;
	vec4 shadowMapCascadeOffsets;
	
	vec2[6] shadowMapViewportOffsets;

	mat4[4] shadowMapTransformationMatrices;
	mat4[4] shadowMapInverseTransformationMatrices;

	mat4[4] shadowMapProjectionMatrices;
};

layout(set=2, binding=0, std140) uniform LightingStateBlock
{
	vec3 ambientLighting;
	uint numberOfLights;
} LightingState;

layout(set=2, binding=1, std430) buffer AllLightsBlock
{
	LightSource[] lights;
} AllLight;

struct LightCluster
{
	vec3 min;
	vec3 max;
};

layout(set=2, binding=2, std430) buffer LightClustersBlock
{
	LightCluster[] clusters;
} LightClusters;

layout(set=2, binding=3, std430) buffer TileLightIndicesBlock
{
	uint[] indices;
} TileLightIndices;

layout(set=2, binding=4, std430) buffer LightClusterListsBlock
{
	uvec2[] lists;
} LightClusterLists;

layout(set=2, binding=5) uniform texture2D ShadowMapTextureAtlas;
layout(set=2, binding=6) uniform texture2D BRDFLutTexture;
layout(set=2, binding=7) uniform textureCube AmbientDiffuseLightProbeTexture;
layout(set=2, binding=8) uniform textureCube AmbientSpecularLightProbeTexture;
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> linearToneMappingOperator [
	^ linearToneMappingOperator
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> linearToneMappingOperatorShaderSource [
	^ '
#version 450
' , self samplerStateSource, self toneMappingOperatorIOSource , self cameraStateBlockSource , '
#line 6


void main()
{
	vec4 hdrColor = textureLod(sampler2D(HDRColorBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	FragmentOutputColor = vec4(hdrColor.rgb * CameraState.exposure, hdrColor.a);
}
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessDepthOnlyFragmentShader [
	^ metallicRoughnessDepthOnlyFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessDepthOnlyFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self cameraStateBlockSource, self metallicRoughnessMaterialStateSource ,'
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;

	vec4 baseColor = StageInput.color * MaterialState.baseColorFactor * texture(sampler2D(BaseColorTexture, TextureSampler), texcoord0);
	if(baseColor.a < MaterialState.alphaCutoff)
		discard;
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessFragmentShaderSourceForOpaquePass: isOpaquePass [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, (self renderFragmentShaderOutputsForOpaquePass: isOpaquePass), self cameraStateBlockSource, self metallicRoughnessLightingModel, self metallicRoughnessMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;
	
	SurfaceLightingParameters lightingParameters;
	
	lightingParameters.baseColor = StageInput.color * MaterialState.baseColorFactor * texture(sampler2D(BaseColorTexture, TextureSampler), texcoord0);
	if(lightingParameters.baseColor.a < MaterialState.alphaCutoff)
		discard;

	lightingParameters.emissiveFactor = StageInput.color.rgb * MaterialState.emissiveFactor.rgb * texture(sampler2D(EmissiveTexture, TextureSampler), texcoord0).rgb;
	vec3 tangentSpaceN = texture(sampler2D(NormalTexture, TextureSampler), texcoord0).rgb*2.0 - 1.0;
	
	vec3 surfaceTangent = normalize(StageInput.tangent4.xyz);
	vec3 surfaceNormal = normalize(StageInput.normal);
	vec3 surfaceBitangent = cross(surfaceNormal, surfaceTangent)*StageInput.tangent4.w;
	mat3 TBN = mat3(surfaceTangent, surfaceBitangent, surfaceNormal);
	lightingParameters.N = normalize(TBN * tangentSpaceN);
	lightingParameters.P = StageInput.viewPosition;
	lightingParameters.V = normalize(-StageInput.viewPosition);
	lightingParameters.worldP = StageInput.worldPosition;
	lightingParameters.worldSurfaceN = normalize(StageInput.worldNormal);

	lightingParameters.occlusionFactor = MaterialState.occlusionFactor * texture(sampler2D(OcclusionTexture, TextureSampler), texcoord0).r;
	vec2 roughnessMetallicFactor = vec2(MaterialState.roughnessFactor, MaterialState.metallicFactor) * texture(sampler2D(MetallicRoughnessTexture, TextureSampler), texcoord0).gb;
	lightingParameters.roughnessFactor = roughnessMetallicFactor.x;
	lightingParameters.metallicFactor = roughnessMetallicFactor.y;
	
	DefineRenderPassDummyOutputs();
	FragmentOutputColor = performLightingModelComputation(lightingParameters, FragmentOutputNormal, FragmentOutputSpecularity);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessLightingModel [
^ self lightingStateBlockSource , self shadowMappingSamplingSource , '
#line 4
const float DistanceEpsilon = 0.00001;

const float Pi = 3.141592653589793;
const float PiReciprocal = 0.3183098861837907;

struct SurfaceLightingParameters
{
	vec4 baseColor;

	vec3 emissiveFactor;
	float occlusionFactor;

	vec3 N;
	float metallicFactor;

	vec3 V;
	float roughnessFactor;

	vec3 P;
	
	vec3 worldP;
	vec3 worldSurfaceN;
};

vec3 fresnelSchlick(vec3 F0, float cosTheta)
{
    float powFactor = 1.0 - cosTheta;
    float powFactor2 = powFactor * powFactor;
    float powFactor4 = powFactor2 * powFactor2;
    float powValue = powFactor4 * powFactor;

    return F0 + (vec3(1.0) - F0) * powValue;
}

vec3 fresnelSchlickRoughness(vec3 F0, float cosTheta, float roughness)
{
	// Function obtained from: https://learnopengl.com/PBR/IBL/Diffuse-irradiance
    float powFactor = 1.0 - cosTheta;
    float powFactor2 = powFactor * powFactor;
    float powFactor4 = powFactor2 * powFactor2;
    float powValue = powFactor4 * powFactor;

    return F0 + (max(vec3(1.0) - roughness, F0) - F0) * powValue;
}

float ggxSpecularDistribution(float alpha, float cosTheta)
{
	float alphaSquare = alpha*alpha;
	float den = cosTheta*cosTheta*(alphaSquare - 1.0) + 1.0;
	return alphaSquare / (Pi * den*den);
}

float smithSchlickBeckmannReciprocalFunction(float k, float cosTheta)
{
    return cosTheta*(1.0 - k) + k;
}

float cookTorranceSmithSchlickGGXMasking(float k, float NdotL, float NdotV)
{
	return 1.0 / (4.0*smithSchlickBeckmannReciprocalFunction(k, NdotL)*smithSchlickBeckmannReciprocalFunction(k, NdotV));
}

float computeLightAttenuation(float distance, float influenceRadius)
{
    float a = distance / max(influenceRadius, DistanceEpsilon);
    float a2 = a*a;
    float a4 = a2*a2;
    float num = clamp(1.0f - a4, 0.0, 1.0);
    return num*num / (distance*distance + 1.0);
}

uint computeLightTileSliceIndexForLinearDepth(float depth)
{
	vec2 scaleAndOffset = CameraState.lightGridDepthSliceScaleOffset;
	return uint(log(-depth)*scaleAndOffset.x + scaleAndOffset.y);
}

uvec3 computeLightTileCoordinateForCurrentScreenCoordinateWithLinearDepth(float depth)
{
	uvec3 gridExtent = CameraState.lightGridExtent;
	vec2 normalizedScreenCoordinate = vec2(gl_FragCoord.xy * CameraState.framebufferReciprocalExtent);
	
	return min(uvec3(uvec2(normalizedScreenCoordinate * vec2(gridExtent.xy)),
		computeLightTileSliceIndexForLinearDepth(depth)), gridExtent - 1u);
}

uint computeLightTileIndexForCurrentScreenCoordinateWithLinearDepth(float depth)
{
	uvec3 gridExtent = CameraState.lightGridExtent;
	uvec3 gridCoordinate = computeLightTileCoordinateForCurrentScreenCoordinateWithLinearDepth(depth);
	
	return gridCoordinate.x + gridCoordinate.y * gridExtent.x + gridCoordinate.z*gridExtent.x*gridExtent.y;
}

vec4 performLightingModelComputation(in SurfaceLightingParameters surfaceParameters, out vec2 gbufferNormal, out vec4 gbufferSpecularity)
{
	vec3 dielectricF0 = vec3(0.04);
	vec3 Cdiffuse = mix(surfaceParameters.baseColor.rgb * (1.0 - dielectricF0), vec3(0.0), surfaceParameters.metallicFactor);
	vec3 diffuse = Cdiffuse * PiReciprocal;
	vec3 F0 = mix(dielectricF0, surfaceParameters.baseColor.rgb, surfaceParameters.metallicFactor);
	
	gbufferNormal = surfaceParameters.N.xy;
	gbufferSpecularity = vec4(F0, surfaceParameters.roughnessFactor);

	float directRoughness = mix(0.01, 1.0, surfaceParameters.roughnessFactor);
	float directAlpha = directRoughness*directRoughness;

	float directKRoughness = (directRoughness + 1.0);
	float directK = directKRoughness*directKRoughness / 8.0;

	float NdotV = max(0.0, dot(surfaceParameters.N, surfaceParameters.V));
			
	vec3 lightedColor = vec3(0);

	mat3 viewToWorld = mat3(CameraState.inverseTransformationMatrix[0].xyz, CameraState.inverseTransformationMatrix[1].xyz, CameraState.inverseTransformationMatrix[2].xyz);
	vec3 worldN = surfaceParameters.N * viewToWorld;
	vec3 worldSurfaceN = surfaceParameters.worldSurfaceN;
	vec3 worldP = surfaceParameters.worldP;

	vec3 R = reflect(-surfaceParameters.V, surfaceParameters.N);
	vec3 worldR = R * viewToWorld;

	// Add the diffuse light probe lighting.
	vec3 diffuseLightProbeSample = textureLod(samplerCube(AmbientDiffuseLightProbeTexture, BrdfLutSampler), worldN, 0.0).rgb;
	lightedColor += diffuseLightProbeSample*diffuse;
	
#if defined(IsInFragmentOpaquePass) && 0
	lightedColor += Cdiffuse*LightingState.ambientLighting;

#else
	// Ambient lighting accumulation.
	lightedColor += surfaceParameters.baseColor.rgb*LightingState.ambientLighting;

	// Add the lighting cube.
	float specularLightProbeLevel = float(textureQueryLevels(samplerCube(AmbientSpecularLightProbeTexture, BrdfLutSampler)) - 1) * surfaceParameters.roughnessFactor;
	vec3 specularLightProbeSample = textureLod(samplerCube(AmbientSpecularLightProbeTexture, BrdfLutSampler), worldR, specularLightProbeLevel).rgb;

	vec2 ambientReflectionFactors = textureLod(sampler2D(BRDFLutTexture, BrdfLutSampler), vec2(NdotV, surfaceParameters.roughnessFactor), 0.0).rg;
	vec3 specularFactor = F0*ambientReflectionFactors.x + ambientReflectionFactors.y;

	// Add the light probe.
	lightedColor += specularLightProbeSample*specularFactor;

#endif
	lightedColor *= surfaceParameters.occlusionFactor;
	lightedColor += surfaceParameters.emissiveFactor;

	// Direct light accumulation.
	uint tileIndex = computeLightTileIndexForCurrentScreenCoordinateWithLinearDepth(surfaceParameters.P.z);
	uvec2 tileLightList = LightClusterLists.lists[tileIndex];
	
	// Shadow mapping sampling data
	ShadowMappingSamplingData shadowMappingSamplingData;
	if(tileLightList.y > 0u)
		computeShadowMappingSamplingData(shadowMappingSamplingData, worldP, worldSurfaceN);
	
	for(uint i = 0u; i < tileLightList.y; ++i)
	{
		uint lightIndex = TileLightIndices.indices[tileLightList.x + i];
	
#define currentLightSource AllLight.lights[lightIndex]

		vec4 lightSourcePosition = currentLightSource.positionOrDirection;
		vec3 L = lightSourcePosition.xyz;
		float lightDistance = 0.0;
		float attenuation = 1.0;
		float lightMaxDistance = 1.0;
		if(lightSourcePosition.w != 0)
		{ 
			L = L - surfaceParameters.P;
			lightDistance = length(L);
			L = L/ max(lightDistance, DistanceEpsilon);
			lightMaxDistance = currentLightSource.influenceRadius;
			attenuation = computeLightAttenuation(lightDistance, currentLightSource.influenceRadius);
		}
		else
		{
			L = normalize(L);
		}
		
		if(currentLightSource.innerSpotCosCutoff > -1.0)
		{
			float spotCos = dot(L, currentLightSource.spotDirection);
			attenuation *= smoothstep(currentLightSource.outerSpotCosCutoff, currentLightSource.innerSpotCosCutoff, spotCos);
		}
		
		// Sample the shadow map, if available.
		if (currentLightSource.castShadows)
		{
			float shadowFactor = sampleShadowMapForLightWithIndex(shadowMappingSamplingData, lightIndex, L, lightDistance, lightMaxDistance);
			if(shadowFactor <= 0.0)
				continue;
				
			attenuation *= shadowFactor;
		}

		float NdotL = max(0.0, dot(surfaceParameters.N, L));
		if(NdotL > 0.0 && attenuation > 0.0)
		{
			vec3 H = normalize(L + surfaceParameters.V);
			float NdotH = max(0.0, dot(surfaceParameters.N, H));
			float VdotH = max(0.0, dot(surfaceParameters.V, H));
			
			vec3 F = fresnelSchlick(F0, VdotH);
			float D = ggxSpecularDistribution(directAlpha, NdotH);
			float G = cookTorranceSmithSchlickGGXMasking(directK, NdotL, NdotV);

			lightedColor += (currentLightSource.intensity * (diffuse + F*(D*G))) * (attenuation*NdotL*Pi);
		}
#undef currentLightSource
	}
	
#ifdef IsInFragmentOpaquePass
	return vec4(lightedColor, surfaceParameters.occlusionFactor);
#else
	return vec4(lightedColor, surfaceParameters.baseColor.a);
#endif
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessMaterialStateSource [
	^ '
layout(set=4, binding=0, std140) uniform MaterialStateBlock	
{
	int doubleSided;
	float alphaCutoff;

	vec4 baseColorFactor;
	vec3 emissiveFactor;

	float occlusionFactor;
	float roughnessFactor;
	float metallicFactor;
		
	vec2 texcoordOffset;
	vec2 texcoordScale;
	vec2 texcoordOffsetVelocity;
} MaterialState;

layout(set=4, binding=1) uniform texture2D BaseColorTexture;
layout(set=4, binding=2) uniform texture2D EmissiveTexture;
layout(set=4, binding=3) uniform texture2D NormalTexture;
layout(set=4, binding=4) uniform texture2D OcclusionTexture;
layout(set=4, binding=5) uniform texture2D MetallicRoughnessTexture;
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessOpaqueFragmentShader [
	^ metallicRoughnessOpaqueFragmentShader
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> metallicRoughnessTranslucentFragmentShader [
	^ metallicRoughnessTranslucentFragmentShader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> neutralNormalTexture [
	^ neutralNormalTexture
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> objectStateBlockSource [
	^ '
layout(set=3, binding=0, std140) uniform ObjectStateBlock
{
	mat4 transformationMatrix;
	mat4 inverseTransformationMatrix;
} ObjectState;

'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> opaqueReflectionCombinationFragmentShader [
	^ opaqueReflectionCombinationFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> opaqueReflectionCombinationFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , '
#line 6

layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D DepthBuffer;
layout(set=4, binding=2) uniform texture2D OpaqueColorBuffer;
layout(set=4, binding=3) uniform texture2D ScreenSpaceAmbientOcclusionTexture;
layout(set=4, binding=4) uniform texture2D StaticReflectionTexture;
layout(set=4, binding=5) uniform texture2D ScreenSpaceReflectionTexture;

void main()
{
	vec4 opaqueColorAndCavity = textureLod(sampler2D(OpaqueColorBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	vec3 opaqueColor = opaqueColorAndCavity.rgb;
	float cavity = opaqueColorAndCavity.a;
	
	float ssaoFactor = textureLod(sampler2D(ScreenSpaceAmbientOcclusionTexture, ScreenTextureSampler), inTexcoord, 0.0).r;
	vec4 staticReflection = textureLod(sampler2D(StaticReflectionTexture, ScreenTextureSampler), inTexcoord, 0.0);
	vec4 screenSpaceReflection = textureLod(sampler2D(ScreenSpaceReflectionTexture, ScreenTextureSampler), inTexcoord, 0.0);
	
	float occlusionFactor = sqrt(cavity*ssaoFactor);

	vec3 reflection = mix(staticReflection.rgb, screenSpaceReflection.rgb, screenSpaceReflection.a);

	vec3 color = opaqueColor + reflection*occlusionFactor;
	FragmentOutputColor = vec4(color, 1.0);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> projectionNDCAdjustMatrix [
	^ projectionNDCAdjustMatrix
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> redCyanAnaglyphComposeShaderSource [
	^ '
#version 450
' , self samplerStateSource, self stereoComposeShaderIOSource , '
#line 6

void main()
{
	vec4 leftEyeColor = textureLod(sampler2D(LeftEyeBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	vec4 rightEyeColor = textureLod(sampler2D(RightEyeBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	FragmentOutputColor = vec4(leftEyeColor.r, rightEyeColor.gb, (leftEyeColor.a + rightEyeColor.a) * 0.5);
}
'
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> reflectionRenderPass [
	| colorAttachment |
	reflectionRenderPass ifNotNil: [ ^ reflectionRenderPass ].
	
	^ [
		| renderpassDescription |
		colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
		colorAttachment
			format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT;
			begin_action: AGPU_ATTACHMENT_DISCARD;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: AGPUColor4f new;
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		reflectionRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> reinhardToneMappingOperatorShaderSource [
	^ '
#version 450
' , self samplerStateSource, self toneMappingOperatorIOSource , self cameraStateBlockSource , '
#line 6


void main()
{
	vec4 hdrTexel = textureLod(sampler2D(HDRColorBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	vec3 hdrColor = hdrTexel.rgb * CameraState.exposure;
	vec3 ldrColor = hdrColor / (hdrColor + 1.0);
	FragmentOutputColor = vec4(ldrColor, hdrTexel.a);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> renderFragmentShaderOutputs [
	^ '
layout(location=0) out vec4 FragmentOutputColor;
layout(location=1) out vec2 FragmentOutputNormal;
layout(location=2) out vec4 FragmentOutputSpecularity;
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> renderFragmentShaderOutputsForOpaquePass: isOpaquePass [
	^ isOpaquePass ifTrue: [
'
layout(location=0) out vec4 FragmentOutputColor;
layout(location=1) out vec2 FragmentOutputNormal;
layout(location=2) out vec4 FragmentOutputSpecularity;
#define DefineRenderPassDummyOutputs()
#define IsInFragmentOpaquePass

'
] ifFalse: [ 
'
layout(location=0) out vec4 FragmentOutputColor;
#define DefineRenderPassDummyOutputs() \
vec2 FragmentOutputNormal; \
vec4 FragmentOutputSpecularity;

'
]
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> rendererShaderSignature [
	^ rendererShaderSignature
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> samplerStateSource [
	^ '
layout(set=0, binding=0) uniform sampler TextureSampler;
layout(set=0, binding=1) uniform sampler ShadowMapSampler;
layout(set=0, binding=2) uniform sampler BrdfLutSampler;
layout(set=0, binding=3) uniform sampler ScreenTextureSampler;
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> screenQuadVertexShader [
	^ screenQuadVertexShader
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> screenSpaceAmbientOcclusionComputationFragmentShader [
	^ screenSpaceAmbientOcclusionComputationFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> screenSpaceAmbientOcclusionComputationFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , '
#line 6

layout(location=0) in vec2 inTexcoord;
layout(location=0) out float FragmentOutputSSAO;

layout(set=4, binding=1) uniform texture2D DepthBuffer;
layout(set=4, binding=2) uniform texture2D NormalGBuffer;

const uint SamplingDistributionSize = 8u;
const vec3[SamplingDistributionSize] SamplingDistribution = vec3[SamplingDistributionSize](
    vec3( -0.6877715587615967, -0.506843626499176, 0.5196920037269592 ),
    vec3( -0.34024709463119507, 0.2696249485015869, 0.9008519649505615 ),
    vec3( 0.8366008996963501, -0.2242094725370407, 0.4998289942741394 ),
    vec3( 0.5788835287094116, -0.8140687346458435, 0.04675422981381416 ),
    vec3( 0.1709364503622055, 0.9850329756736755, 0.022153066471219063 ),
    vec3( 0.8136236667633057, 0.519911527633667, 0.2602085471153259 ),
    vec3( -0.8440455198287964, 0.44032758474349976, 0.3061026632785797 ),
    vec3( 0.1833304911851883, -0.7002113461494446, 0.6899957060813904 )
);

float sampleAmbientOcclusionAt(float eyeDepth, vec3 position)
{
	vec4 projectedPosition = CameraState.projectionMatrix * vec4(position, 1.0);
	if(projectedPosition.w == 0.0)
		return 1.0;

	vec3 samplePoint = projectedPosition.xyz / projectedPosition.w;
	float sampleDepth = textureLod(sampler2D(DepthBuffer, ScreenTextureSampler), samplePoint.xy*0.5 + 0.5, 0.0).r;

	// Large variations of depth can introduce some false positives.
	// TODO: Find the place where this thesholding function was originally found.
	float threshold = abs(eyeDepth - samplePoint.z)*10.0;
	float attenuation = 1.0 - smoothstep(threshold, threshold*2.0, abs(sampleDepth - samplePoint.z));
	return (sampleDepth - 0.00001 < samplePoint.z ? 0.0 : 1.0)*attenuation;
}

float signedRandomNoise(vec2 coord)
{
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

mat3 rotationMatrixFor(float s)
{
	float c = sqrt(1.0 - s*s);
	return mat3(
		vec3(c, s, 0.0),
		vec3(-s, c, 0.0),
		vec3(0.0, 0.0, 1.0)
	);
}

void main()
{
	float depth = textureLod(sampler2D(DepthBuffer, ScreenTextureSampler), inTexcoord, 0.0).r;
	vec2 screenNormal = textureLod(sampler2D(NormalGBuffer, ScreenTextureSampler), inTexcoord, 0.0).xy;
	vec3 N = normalize(vec3(screenNormal, sqrt(max(1.0 - (screenNormal.x*screenNormal.x + screenNormal.y*screenNormal.y), 0.0))));

	vec4 ndcPosition = vec4(inTexcoord*2.0 - 1.0, depth, 1.0);
	if(CameraState.hasTopLeftNDCOrigin == CameraState.hasBottomLeftTextureCoordinates)
		ndcPosition.y = -ndcPosition.y;
	
	vec4 clipSpacePosition = CameraState.inverseProjectionMatrix*ndcPosition;
	vec3 viewPosition = clipSpacePosition.xyz / clipSpacePosition.w;
	
	vec3 upVector = abs(N.y) >= 0.9 ? vec3(1.0, 0.0, 1.0) : vec3(0.0, 1.0, 1.0);
	vec3 tangent = normalize(cross(upVector, N));
	vec3 bitangent = cross(N, tangent);
	
	mat3 tbn = mat3(tangent, bitangent, N) * rotationMatrixFor(signedRandomNoise(inTexcoord*123456.0f));

	float outputSampleCount = 0.0;
	for(uint i = 0u; i < SamplingDistributionSize; ++i)
	{ 
		vec3 delta = tbn * SamplingDistribution[i];
		outputSampleCount += sampleAmbientOcclusionAt(depth, viewPosition + delta);
	}
	
	FragmentOutputSSAO = 1.0 - outputSampleCount / float(SamplingDistributionSize);
}
'
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> screenSpaceAmbientOcclusionRenderPass [
	| colorAttachment |
	screenSpaceAmbientOcclusionRenderPass ifNotNil: [ ^ screenSpaceAmbientOcclusionRenderPass ].
	
	^ [
		| renderpassDescription |
		colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
		colorAttachment
			format: AGPU_TEXTURE_FORMAT_R8_UNORM;
			begin_action: AGPU_ATTACHMENT_DISCARD;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: AGPUColor4f new;
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		screenSpaceAmbientOcclusionRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> screenSpaceReflectionComputationFragmentShader [
	^ screenSpaceReflectionComputationFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> screenSpaceReflectionComputationFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self cameraStateBlockSource , '
#line 6

layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputScreenSpaceReflection;

layout(set=4, binding=1) uniform texture2D DepthBuffer;
layout(set=4, binding=2) uniform texture2D NormalGBuffer;
layout(set=4, binding=3) uniform texture2D SpecularGBuffer;

layout(set=4, binding=4) uniform texture2D GlossColorBuffer;
layout(set=4, binding=5) uniform texture2D RoughColorBuffer;

const uint SampleCount = 20u;
const float StepDistance = 0.5;
const float HitDepthThreshold = 0.001;

void main()
{
	vec4 specularColor = textureLod(sampler2D(SpecularGBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	if(specularColor == vec4(0.0, 0.0, 0.0, 0.0))
	{
		FragmentOutputScreenSpaceReflection = vec4(0.0);
		return;
	}

	vec3 F0 = specularColor.xyz;
	float roughnessFactor = specularColor.w;

	float depth = textureLod(sampler2D(DepthBuffer, ScreenTextureSampler), inTexcoord, 0.0).r;
	vec2 screenNormal = textureLod(sampler2D(NormalGBuffer, ScreenTextureSampler), inTexcoord, 0.0).xy;
	vec3 N = vec3(screenNormal, sqrt(max(1.0 - (screenNormal.x*screenNormal.x + screenNormal.y*screenNormal.y), 0.0)));

	vec4 ndcPosition = vec4(inTexcoord*2.0 - 1.0, depth, 1.0);
	if(CameraState.hasTopLeftNDCOrigin == CameraState.hasBottomLeftTextureCoordinates)
		ndcPosition.y = -ndcPosition.y;
	
	vec4 clipSpacePosition = CameraState.inverseProjectionMatrix*ndcPosition;
	vec3 viewPosition = clipSpacePosition.xyz / clipSpacePosition.w;
	vec3 V = normalize(-viewPosition);
	vec3 R = reflect(-V, N);
	
	vec3 rayMarchDelta = R*StepDistance;
	vec3 rayMarchPoint = viewPosition + rayMarchDelta;
	vec2 reflectionScreenPoint = vec2(0.0);
	bool hasHit = false;
	float hitAlpha = 0.0;
	
	for(uint i = 0u; i < SampleCount; ++i, rayMarchPoint += rayMarchDelta)
	{
		vec4 rayMarchProjectedPoint = CameraState.projectionMatrix * vec4(rayMarchPoint, 1.0);
		if(rayMarchProjectedPoint.w == 0.0)
			break;
		
		vec3 rayMarchNDCPoint = rayMarchProjectedPoint.xyz / rayMarchProjectedPoint.w;
		if(CameraState.hasTopLeftNDCOrigin == CameraState.hasBottomLeftTextureCoordinates)
			rayMarchNDCPoint.y = -rayMarchNDCPoint.y;
		
		reflectionScreenPoint = rayMarchNDCPoint.xy*0.5 + 0.5;
		if(reflectionScreenPoint.x < 0.0 || reflectionScreenPoint.x > 1.0 ||
			reflectionScreenPoint.y < 0.0 || reflectionScreenPoint.y > 1.0 ||
			rayMarchNDCPoint.z < 0.0)
			break;
		
		float rayMarchDepth = rayMarchNDCPoint.z;
		float sampleDepth = textureLod(sampler2D(DepthBuffer, ScreenTextureSampler), reflectionScreenPoint, 0.0).r;
		
		float depthDelta = rayMarchDepth - sampleDepth;
		hasHit = CameraState.hasReverseDepth ? depthDelta <= HitDepthThreshold : depthDelta >= HitDepthThreshold;
		//hasHit = CameraState.hasReverseDepth ? depthDelta >= HitDepthThreshold : depthDelta <= HitDepthThreshold;
		if(hasHit)
		{
			hitAlpha = 1.0 - float(i)/float(SampleCount);
			break;
		}
	}
	
	if(hasHit)
	{
		vec3 reflectionColor = mix(
			textureLod(sampler2D(GlossColorBuffer, ScreenTextureSampler), reflectionScreenPoint, 0.0).rgb,
			textureLod(sampler2D(RoughColorBuffer, ScreenTextureSampler), reflectionScreenPoint, 0.0).rgb,
			specularColor.a)*specularColor.rgb;

		FragmentOutputScreenSpaceReflection = vec4(reflectionColor, hitAlpha);
	}
	else
	{ 
		FragmentOutputScreenSpaceReflection = vec4(0.0);
	}	
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> shadowMapAtlasAllocator [
	^ shadowMapAtlasAllocator
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> shadowMapAtlasExtent [
	^ ShadowMapAtlasExtent
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> shadowMapAtlasFramebuffer [
	^ shadowMapAtlasFramebuffer
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> shadowMapAtlasTexture [
	^ shadowMapAtlasTexture
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> shadowMapAtlasTextureSamplingView [
	^ shadowMapAtlasTextureSamplingView
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> shadowMapRenderPass [
	| renderpassDescription depthStencilAttachment |
	shadowMapRenderPass ifNotNil: [ ^ shadowMapRenderPass ].
	
	^ [
		depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew
			format: AGPU_TEXTURE_FORMAT_D32_FLOAT;
			begin_action: AGPU_ATTACHMENT_KEEP;
			end_action: AGPU_ATTACHMENT_KEEP;
			stencil_begin_action: AGPU_ATTACHMENT_KEEP;
			stencil_end_action: AGPU_ATTACHMENT_KEEP;
			sample_count: 1;
			yourself.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription depth_stencil_attachment: depthStencilAttachment.
		shadowMapRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [ depthStencilAttachment free ]

]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> shadowMappingSamplingSource [
	^ self cubeMapFaceRotationMatricesShaderSource , '
#line 4

const uint PcfMinSampleCount = 5u;
const uint PcfMaxSampleCount = 16u;
const uint PcfMaxAvailableSampleCount = 16u;

const vec2[PcfMaxAvailableSampleCount] PcfSamplingDisk = vec2[PcfMaxAvailableSampleCount](
	vec2(0.0, 0.0),
	vec2(0.5112106443900664, -0.08269973615310144),
	vec2(-0.9059107675710277, 0.3577294337366379),
	vec2(0.35859281167322443, 0.8693857918816552),
	vec2(-0.23316869849021016, -0.8663155249628777),
	vec2(0.0655344748243385, -0.5620816273438193),
	vec2(-0.16502805108438623, 0.37354542472099217),
	vec2(0.8206416609793163, 0.5243960793709364),
	vec2(-0.45458006647163074, -0.12717718869781924),
	vec2(0.9732842240358164, -0.012046630034244887),
	vec2(-0.4458363994238136, 0.8276348839642642),
	vec2(0.6556346005087879, -0.7492692488009433),
	vec2(-0.6804649548979779, -0.5744969703138326),
	vec2(0.3779618262210682, 0.4044132974950658),
	vec2(-0.8987948111718497, -0.04439136527683185),
	vec2(-0.032797453474624705, 0.773199451981671)
);

float sampleShadowMapForLightWithIndexAtPoint(uint lightIndex, vec3 worldSamplePosition)
{
#define lightSource AllLight.lights[lightIndex]
	
	vec4 lightProjectedPosition;
	uint samplingLayer = 0u;
	
	// Is this a non-directional light.
	if(lightSource.positionOrDirection.w != 0.0)
	{ 
		if(lightSource.innerSpotCosCutoff > -1.0)
		{ 
			// Spot light.
			lightProjectedPosition = lightSource.shadowMapProjectionMatrices[0] * (lightSource.shadowMapInverseTransformationMatrices[0] * vec4(worldSamplePosition, 1.0));
		}
		else
		{
			// Omni-directional. Select the adequate cube map face.
			vec3 lightVector = worldSamplePosition - lightSource.shadowMapTransformationMatrices[0][3].xyz;			
			vec3 absLightVector = abs(lightVector);
			if(absLightVector.x >= absLightVector.y)
			{
				if(absLightVector.x >= absLightVector.z)
					samplingLayer = lightVector.x < 0.0 ? 1u : 0u;
				else
					samplingLayer = lightVector.z < 0.0 ? 5u : 4u;
			}
			else
			{ 
				if(absLightVector.y >= absLightVector.z)
					samplingLayer = lightVector.y < 0.0 ? 3u : 2u;
				else
					samplingLayer = lightVector.z < 0.0 ? 5u : 4u;
			}
			
			
			lightProjectedPosition = lightSource.shadowMapProjectionMatrices[0] * vec4(CubeMapInverseFaceRotations[samplingLayer]*lightVector, 1.0); 
		}
	}
	else
	{
		// Select the directional shadow map cascade.
		float cascadeDistance = dot(lightSource.shadowMapCascadeDistanceWorldTransform, vec4(worldSamplePosition, 1.0));
		vec4 cascadeOffsets = lightSource.shadowMapCascadeOffsets;
		if(cascadeDistance <= cascadeOffsets.y)
		{
			if(cascadeDistance <= cascadeOffsets.x)
				samplingLayer = 0u;
			else
				samplingLayer = 1u;
		}
		else
		{ 
			if(cascadeDistance <= cascadeOffsets.z)
				samplingLayer = 2u;
			else
				samplingLayer = 3u;
		}
		
		// Apply the transform to the corresponding cascade.
		lightProjectedPosition = lightSource.shadowMapProjectionMatrices[samplingLayer] * (lightSource.shadowMapInverseTransformationMatrices[samplingLayer] * vec4(worldSamplePosition, 1.0));
	}
	
	// Avoid division by zero
	if (lightProjectedPosition.w == 0.0) 
		return 0.0;

	// Clip to unit cube.
	vec3 samplePosition = lightProjectedPosition.xyz / lightProjectedPosition.w;
	if(samplePosition.x < -1.0 || samplePosition.x > 1.0
		|| samplePosition.y < -1.0 || samplePosition.y > 1.0)
		return 0.0;
		
	vec3 atlasSamplePosition = vec3(samplePosition.xy*lightSource.shadowMapViewportScale + lightSource.shadowMapViewportOffsets[samplingLayer], samplePosition.z);

	return textureLod(sampler2DShadow(ShadowMapTextureAtlas, ShadowMapSampler), atlasSamplePosition, 0.0);
}

struct ShadowMappingSamplingData
{
	vec3 position;
	vec3 normal;
	vec3 tangent;
	vec3 bitangent;
};

void computeShadowMappingSamplingData(out ShadowMappingSamplingData samplingData, vec3 worldPosition, vec3 worldNormal)
{
	samplingData.position = worldPosition;
	samplingData.normal = worldNormal;
	
	float randomFloat = fract(sin(dot(worldPosition, vec3(12.9898, 78.233, 217.179))) * 43758.5453);
	float s = randomFloat*2.0 - 1.0;
	float c = sqrt(1.0 - s*s);
	vec3 upVector = vec3(c, s, 0.0);
	if(abs(dot(upVector, samplingData.normal)) > 0.9)
		upVector = vec3(-s, c, 0.0);

	samplingData.tangent = normalize(cross(upVector, samplingData.normal));
	samplingData.bitangent = cross(samplingData.normal, samplingData.tangent);
}

float sampleShadowMapForLightWithIndex(in ShadowMappingSamplingData samplingData, uint lightIndex, vec3 lightVector, float lightDistance, float lightMaxDistance)
{
	vec3 sampleCenterPoint = samplingData.position + samplingData.normal*0.01;

	float sampleSum = 0.0;
	uint sampleCount = 0u;
	
	float diskRadius = mix(0.002, 0.02, lightDistance / lightMaxDistance);

	// Perform an initial number of samples for fully in shadow
	for(; sampleCount < PcfMinSampleCount; ++sampleCount)
	{
		vec2 sampleVector = PcfSamplingDisk[sampleCount]*diskRadius;
		vec3 samplePosition = sampleCenterPoint + samplingData.tangent*sampleVector.x + samplingData.bitangent*sampleVector.y;

		sampleSum += sampleShadowMapForLightWithIndexAtPoint(lightIndex, samplePosition);
	}
	
	// Check for fully shadowed or in light zones.
	if(sampleSum == 0.0)
		return 0.0;
	else if(sampleSum == float(PcfMinSampleCount))
		return 1.0;

	// Perform the remaining samples.
	for(; sampleCount < PcfMaxSampleCount; ++sampleCount)
	{
		vec2 sampleVector = PcfSamplingDisk[sampleCount]*diskRadius;
		vec3 samplePosition = sampleCenterPoint + samplingData.tangent*sampleVector.x + samplingData.bitangent*sampleVector.y;

		sampleSum += sampleShadowMapForLightWithIndexAtPoint(lightIndex, samplePosition);
	}

	return sampleSum / float(PcfMaxSampleCount);
}

'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> sideBySideStereoComposeShaderSource [
	^ '
#version 450
' , self samplerStateSource, self stereoComposeShaderIOSource , '
#line 6

void main()
{
	if(inTexcoord.x < 0.5)
		FragmentOutputColor = textureLod(sampler2D(LeftEyeBuffer, ScreenTextureSampler), inTexcoord * vec2(2.0, 1.0), 0.0);
	else
		FragmentOutputColor = textureLod(sampler2D(RightEyeBuffer, ScreenTextureSampler), inTexcoord * vec2(2.0, 1.0) - vec2(1.0, 0.0), 0.0);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> staticReflectionComputationFragmentShader [
	^ staticReflectionComputationFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> staticReflectionComputationFragmentShaderSource [
	^ '
#version 450
' , self lightingStateBlockSource , self samplerStateSource, self cameraStateBlockSource , '
#line 6

layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputStaticReflection;

layout(set=4, binding=1) uniform texture2D DepthBuffer;
layout(set=4, binding=2) uniform texture2D NormalGBuffer;
layout(set=4, binding=3) uniform texture2D SpecularGBuffer;

void main()
{
	vec4 specularColor = textureLod(sampler2D(SpecularGBuffer, ScreenTextureSampler), inTexcoord, 0.0);
	if(specularColor == vec4(0.0, 0.0, 0.0, 0.0))
	{
		FragmentOutputStaticReflection = vec4(0.0);
		return;
	}

	vec3 F0 = specularColor.xyz;
	float roughnessFactor = specularColor.w;


	float depth = textureLod(sampler2D(DepthBuffer, ScreenTextureSampler), inTexcoord, 0.0).r;
	vec2 screenNormal = textureLod(sampler2D(NormalGBuffer, ScreenTextureSampler), inTexcoord, 0.0).xy;
	vec3 N = vec3(screenNormal, sqrt(max(1.0 - (screenNormal.x*screenNormal.x + screenNormal.y*screenNormal.y), 0.0)));

	vec4 ndcPosition = vec4(inTexcoord*2.0 - 1.0, depth, 1.0);
	if(CameraState.hasTopLeftNDCOrigin == CameraState.hasBottomLeftTextureCoordinates)
		ndcPosition.y = -ndcPosition.y;
	
	vec4 clipSpacePosition = CameraState.inverseProjectionMatrix*ndcPosition;
	vec3 viewP = clipSpacePosition.xyz / clipSpacePosition.w;
	vec3 V = normalize(-viewP);
	float NdotV = max(0.0, dot(N, V));


	// Add the ambient lighting.
	vec3 specularLightedColor = F0*LightingState.ambientLighting;

	// Common factors for adding the different light probes samples.
	vec3 R = reflect(-V, N);

	mat3 viewToWorld = mat3(CameraState.inverseTransformationMatrix[0].xyz, CameraState.inverseTransformationMatrix[1].xyz, CameraState.inverseTransformationMatrix[2].xyz);
	vec3 worldR = R * viewToWorld;

	vec2 ambientReflectionFactors = textureLod(sampler2D(BRDFLutTexture, BrdfLutSampler), vec2(NdotV, roughnessFactor), 0.0).rg;
	vec3 iblSpecularFactor = F0*ambientReflectionFactors.x + ambientReflectionFactors.y;

	// Add the global light probe
#if 0
	{
		float specularLightProbeLevel = float(textureQueryLevels(samplerCube(AmbientSpecularLightProbeTexture, BrdfLutSampler)) - 1) * roughnessFactor;
		specularLightedColor += textureLod(samplerCube(AmbientSpecularLightProbeTexture, BrdfLutSampler), worldR, specularLightProbeLevel).rgb*iblSpecularFactor;
	}
#endif

	FragmentOutputStaticReflection = vec4(specularLightedColor, 0.0);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> stereoComposeShaderFor: composeMode [
	^ stereoComposeModeShaderDictionary at: composeMode
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> stereoComposeShaderIOSource [
	^ '
layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D LeftEyeBuffer;
layout(set=4, binding=2) uniform texture2D RightEyeBuffer;
'

]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> textureUploader [
	^ textureUploader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> tileLightIndexListBuffer [
	^ tileLightIndexListBuffer
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> toneMappingOperatorIOSource [
	^ '
layout(location=0) in vec2 inTexcoord;
layout(location=0) out vec4 FragmentOutputColor;

layout(set=4, binding=1) uniform texture2D HDRColorBuffer;
'

]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> toneMappingOperatorShaderFor: aToneMapOperator [
	^ toneMapOperatorShaderDictionary at: aToneMapOperator ifAbsent:[ linearToneMappingOperator ]
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> topBottomStereoComposeShaderSource [
	^ '
#version 450
' , self samplerStateSource, self stereoComposeShaderIOSource , '
#line 6

void main()
{
	if(inTexcoord.x < 0.5)
		FragmentOutputColor = textureLod(sampler2D(RightEyeBuffer, ScreenTextureSampler), inTexcoord * vec2(1.0, 2.0), 0.0);
	else
		FragmentOutputColor = textureLod(sampler2D(LeftEyeBuffer, ScreenTextureSampler), inTexcoord * vec2(0.0, 2.0) - vec2(0.0, 1.0), 0.0);
}
'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> transparentTexture2D [
	^ transparentTexture2D
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> transparentTextureCube [
	^ transparentTextureCube
]

{ #category : #'private shaders' }
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

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> unlitDepthOnlyFragmentShader [
	^ unlitDepthOnlyFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> unlitDepthOnlyFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self cameraStateBlockSource, self unlitMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;
	
	vec4 color = StageInput.color * MaterialState.colorFactor * texture(sampler2D(ColorTexture, TextureSampler), texcoord0);
	if(color.a < MaterialState.alphaCutoff)
		discard;
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> unlitFragmentShaderSourceForOpaquePass: isOpaquePass [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self cameraStateBlockSource, (self renderFragmentShaderOutputsForOpaquePass: isOpaquePass), self unlitMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;
	texcoord0 = texcoord0*MaterialState.texcoordScale + MaterialState.texcoordOffset + MaterialState.texcoordOffsetVelocity*CameraState.currentTime;
	
	vec4 color = StageInput.color * MaterialState.colorFactor * texture(sampler2D(ColorTexture, TextureSampler), texcoord0);
	if(color.a < MaterialState.alphaCutoff)
		discard;
		
	DefineRenderPassDummyOutputs();
	FragmentOutputColor = color;
	FragmentOutputNormal = vec2(0.0);
	FragmentOutputSpecularity = vec4(0.0);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> unlitMaterialStateSource [
	^ '
layout(set=4, binding=0, std140) uniform MaterialStateBlock
{
	int doubleSided;
	float alphaCutoff;
	vec4 colorFactor;
		
	vec2 texcoordOffset;
	vec2 texcoordScale;
	vec2 texcoordOffsetVelocity;
} MaterialState;

layout(set=4, binding=1) uniform texture2D ColorTexture;
'
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> unlitOpaqueFragmentShader [
	^ unlitOpaqueFragmentShader
]

{ #category : #'accessing shaders' }
WDAGPUSceneRendererResourceCache >> unlitTranslucentFragmentShader [
	^ unlitTranslucentFragmentShader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> uploadBuffer [
	^ uploadBuffer
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
			usage_modes: ((AGPU_ARRAY_BUFFER bitOr: AGPU_ELEMENT_ARRAY_BUFFER) bitOr: AGPU_COPY_DESTINATION_BUFFER);
			main_usage_mode: (AGPU_ARRAY_BUFFER bitOr: AGPU_ELEMENT_ARRAY_BUFFER);
			mapping_flags: AGPU_MAP_DYNAMIC_STORAGE_BIT;
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
	aWDBinaryBufferAccessor bufferView ifNil: [ ^ nil ].
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
	aWDFramebuffer swapChain ifNotNil: [ :swapChain | ^ swapChain getCurrentBackBuffer ].
	
	cachedFramebuffer := framebuffers at: aWDFramebuffer ifAbsentPut: [ WDAGPUSceneRendererCachedResource new ].
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
WDAGPUSceneRendererResourceCache >> validIntermediateFramebuffersFor: aWDFramebuffer sampleCount: sampleCount initialDepth: initialDepth [
	| result |
	result := intermediateFramebuffers at: aWDFramebuffer ifAbsent: [ nil ].
	result ifNotNil: [ 
		(result extent = aWDFramebuffer extent and: [ result sampleCount = sampleCount and: [ result initialDepth = initialDepth ] ]) ifTrue: [ ^ result ]
	].

	result := WDAGPUIntermediateFramebuffersForExtent for: device resourceCache: self withExtent: aWDFramebuffer extent sampleCount: sampleCount initialDepth: initialDepth.
	intermediateFramebuffers at: aWDFramebuffer put: result.
	
	^ result
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
WDAGPUSceneRendererResourceCache >> validTextureViewHandleFor: aWDTexture [
	| textureHandle |
	textureHandle := self validTextureHandleFor: aWDTexture.
	^ { textureHandle getOrCreateFullView . textureHandle }
]

{ #category : #handles }
WDAGPUSceneRendererResourceCache >> validVertexBindingFor: aWDVertexBufferBinding [
	| cachedVertexBinding attributeBuffers offsets |
	aWDVertexBufferBinding ifNil: [ ^ nil ].
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
		offsets unsignedLongAt: index*4 - 3 put: accessor byteOffset + accessor bufferView byteOffset
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

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> vertexAttributesForMask: locationMask [
	^ ByteString streamContents: [:out |
		#(
			0 (POSITION 'vec3 inPosition')
			1 (COLOR 'vec4 inColor')
			2 (NORMAL 'vec3 inNormal')
			3 (TEXCOORD0 'vec2 inTexcoord0')
			4 (TEXCOORD1 'vec2 inTexcoord1')
			5 (BONE_INDICES 'uvec4 inBoneIndices')
			6 (BONE_WEIGHTS 'vec4 inBoneWeights')
			7 (TANGENT4 'vec4 inTangent4')
		) pairsDo: [ :location :definition |
			(locationMask anyMask: (1 bitShift: location)) ifTrue: [ 
				out nextPutAll: '#define HAS_PER_VERTEX_'; nextPutAll: definition first; cr.
				out nextPutAll: 'layout(location = '; print: location; nextPutAll: ') in '; nextPutAll: definition second; nextPut: $;; cr
			]
		]
	]
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
			begin_action: AGPU_ATTACHMENT_DISCARD;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: AGPUColor4f new;
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		viewportOutputRenderPass := device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> whiteTexture2D [
	^ whiteTexture2D
]
