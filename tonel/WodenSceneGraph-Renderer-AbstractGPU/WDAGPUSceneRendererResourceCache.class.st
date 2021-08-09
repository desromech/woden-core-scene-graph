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
		'forwardMetallicRoughnessFragmentShader',
		'forwardUnlitFragmentShader',
		'genericSurfaceMaterialVertexShaders',
		'whiteTexture2D',
		'transparentTexture2D',
		'neutralNormalTexture',
		'projectionNDCAdjustMatrix',
		'brdfLutTexture'
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
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Resources'
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

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> brdfLutTexture [
	^ brdfLutTexture
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> cameraStateBlockSource [
	^ '
layout(set=1, binding=0, std140) uniform CameraStateBlock	
{
	mat4 transformationMatrix;
	mat4 inverseTransformationMatrix;

	mat4 projectionMatrix;
	float currentTime;
	float exposure;
} CameraState;
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

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> defaultMaterial [
	^ defaultMaterial
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> device [
	^ device
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> forwardFragmentShaderOutputs [
	^ '
layout(location=0) out vec4 FragmentOutputColor;
'
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> forwardMetallicRoughnessFragmentShader [
	^ forwardMetallicRoughnessFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> forwardMetallicRoughnessFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self forwardMetallicRoughnessLightingModel, self metallicRoughnessMaterialStateSource , '
#line 6

void main()
{
	vec2 texcoord0 = StageInput.texcoord0;

	SurfaceLightingParameters lightingParameters;
	
	lightingParameters.baseColor = StageInput.color * MaterialState.baseColorFactor * texture(sampler2D(BaseColorTexture, TextureSampler), texcoord0);
	if(lightingParameters.baseColor.a < MaterialState.alphaCutoff)
		discard;

	lightingParameters.emissiveFactor = StageInput.color.rgb * MaterialState.emissiveFactor.rgb * texture(sampler2D(EmissiveTexture, TextureSampler), texcoord0).rgb;
	vec3 tangentSpaceN = texture(sampler2D(NormalTexture, TextureSampler), texcoord0).rgb*2.0 - 1.0;
	lightingParameters.N = normalize(mat3(StageInput.tangent, StageInput.bitangent, StageInput.normal) * tangentSpaceN);
	lightingParameters.P = StageInput.viewPosition;
	lightingParameters.V = normalize(-StageInput.viewPosition);

	lightingParameters.occlusionFactor = MaterialState.occlusionFactor * texture(sampler2D(OcclusionTexture, TextureSampler), texcoord0).r;
	vec2 roughnessMetallicFactor = vec2(MaterialState.roughnessFactor, MaterialState.metallicFactor) * texture(sampler2D(MetallicRoughnessTexture, TextureSampler), texcoord0).gb;
	lightingParameters.roughnessFactor = roughnessMetallicFactor.x;
	lightingParameters.metallicFactor = roughnessMetallicFactor.y;
	
	FragmentOutputColor = performLightingModelComputation(lightingParameters);
}
'
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> forwardMetallicRoughnessLightingModel [
^ self lightingStateBlockSource , self forwardFragmentShaderOutputs , '
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

vec4 performLightingModelComputation(in SurfaceLightingParameters surfaceParameters)
{
	vec3 dielectricF0 = vec3(0.04);
	vec3 Cdiffuse = mix(surfaceParameters.baseColor.rgb * (1.0 - dielectricF0), vec3(0.0), surfaceParameters.metallicFactor);
	vec3 diffuse = Cdiffuse * PiReciprocal;
	vec3 F0 = mix(dielectricF0, surfaceParameters.baseColor.rgb, surfaceParameters.metallicFactor);

	float directRoughness = mix(0.01, 1.0, surfaceParameters.roughnessFactor);
	float directAlpha = directRoughness*directRoughness;

	float directKRoughness = (directRoughness + 1.0);
	float directK = directKRoughness*directKRoughness / 8.0;

	float NdotV = max(0.0, dot(surfaceParameters.N, surfaceParameters.V));
			
	vec3 lightedColor = vec3(0);
	
	// Ambient lighting accumulation.
	lightedColor += surfaceParameters.baseColor.rgb*LightingState.ambientLighting;

	// TODO: Add support for image based lighting.
	
	lightedColor *= surfaceParameters.occlusionFactor;
	lightedColor += surfaceParameters.emissiveFactor;
	
	// Direct light accumulation.
	uint lightCount = min(LightingState.numberOfLights, 8u);
	for(uint i = 0u; i < lightCount; ++i)
	{
#define currentLightSource LightingState.lights[i]
		vec4 lightSourcePosition = currentLightSource.positionOrDirection;
		vec3 L = lightSourcePosition.xyz;
		float attenuation = 1.0;
		if(lightSourcePosition.w != 0)
		{ 
			L = L - surfaceParameters.P;
			float lightDistance = length(L);
			L = L/ max(lightDistance, DistanceEpsilon);
			attenuation = computeLightAttenuation(lightDistance, currentLightSource.influenceRadius);
		}
		else
		{
			L = normalize(L);
		}
		
		if(currentLightSource.outerSpotCosCutoff > -0.5)
		{
			float spotCos = dot(L, currentLightSource.spotDirection);
			attenuation *= smoothstep(currentLightSource.outerSpotCosCutoff, currentLightSource.innerSpotCosCutoff, spotCos);
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
	
	return vec4(lightedColor, surfaceParameters.baseColor.a);
}
'
]

{ #category : #initialization }
WDAGPUSceneRendererResourceCache >> forwardUnlitFragmentShader [
	^ forwardUnlitFragmentShader
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> forwardUnlitFragmentShaderSource [
	^ '
#version 450
' , self samplerStateSource, self genericSurfaceMaterialFragmentShaderInputs, self forwardFragmentShaderOutputs, self unlitMaterialStateSource , '
#line 6

void main()
{ 
	vec4 color = StageInput.color * MaterialState.colorFactor * texture(sampler2D(ColorTexture, TextureSampler), StageInput.texcoord0);
	if(color.a < MaterialState.alphaCutoff)
		discard;
		
	FragmentOutputColor = color;
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
	vec3 tangent;
	vec3 bitangent;
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
	vec3 tangent;
	vec3 bitangent;
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

vec3 transformFormWorldToView(vec3 normal)
{ 
	return normal *
		mat3(CameraState.transformationMatrix[0].xyz,
		CameraState.transformationMatrix[1].xyz,
		CameraState.transformationMatrix[2].xyz);
}

vec3 transformNormalToView(vec3 normal)
{ 
	return transformFormWorldToView(transformNormalToWorld(normal));
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
	StageOutput.normal = transformNormalToView(inNormal);
#	ifdef HAS_PER_VERTEX_TANGENT4
	StageOutput.tangent = transformNormalToView(inTangent4.xyz);
	StageOutput.bitangent = cross(StageOutput.normal, StageOutput.tangent)*inTangent4.w;
#	else
	vec3 upVector = vec3(0.0, 1.0, 0.0);
	StageOutput.tangent = cross(upVector, StageOutput.normal);
	StageOutput.bitangent = cross(StageOutput.normal, StageOutput.tangent);
#	endif
#else
	StageOutput.normal = vec3(0.0, 0.0, 1.0);
	StageOutput.tangent = vec3(1.0, 0.0, 0.0);
	StageOutput.bitangent = vec3(0.0, 1.0, 0.0);
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
WDAGPUSceneRendererResourceCache >> initializeWithDevice: aDevice withTextureUploader: aTextureUploader [
	device := aDevice.
	textureUploader := aTextureUploader.
	textures := WeakKeyDictionary new.
	framebuffers := WeakKeyDictionary new.
	buffers := WeakKeyDictionary new.
	vertexBindings := WeakKeyDictionary new.
	rendererShaderSignature := WDAGPURendererShaderSignature for: device.
	vertexLayouts := Dictionary new.
	
	whiteTexture2D := self createTexture2DWithSingleColor: #[255 255 255 255].
	transparentTexture2D := self createTexture2DWithSingleColor: #[0 0 0 0].
	neutralNormalTexture := self createTexture2DWithSingleColor: #[128 128 255 255].
	
	genericSurfaceMaterialVertexShaders := Dictionary new.
	forwardMetallicRoughnessFragmentShader := self compileShader: self forwardMetallicRoughnessFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	forwardUnlitFragmentShader := self compileShader: self forwardUnlitFragmentShaderSource type: AGPU_FRAGMENT_SHADER.
	defaultMaterial := WDMetallicRoughnessMaterial default.
	projectionNDCAdjustMatrix :=
		device hasTopLeftNdcOrigin ~~ 0
			ifTrue: [ Matrix4x4 projectionInvertYMatrix ]
			ifFalse: [ Matrix4x4 identity ].
	brdfLutTexture := textureUploader createAndComputeBRDFLut.
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
};

layout(set=2, binding=0, std140) uniform LightingStateBlock	
{
	vec3 ambientLighting;
	uint numberOfLights;
	LightSource[8] lights;
} LightingState;

layout(set=2, binding=1) uniform texture2D BRDFLutTexture;
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
} MaterialState;

layout(set=4, binding=1) uniform texture2D BaseColorTexture;
layout(set=4, binding=2) uniform texture2D EmissiveTexture;
layout(set=4, binding=3) uniform texture2D NormalTexture;
layout(set=4, binding=4) uniform texture2D OcclusionTexture;
layout(set=4, binding=5) uniform texture2D MetallicRoughnessTexture;
'
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

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> projectionNDCAdjustMatrix [
	^ projectionNDCAdjustMatrix
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> rendererShaderSignature [
	^ rendererShaderSignature
]

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> samplerStateSource [
	^ '
layout(set=0, binding=0) uniform sampler TextureSampler	;

'
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> textureUploader [
	^ textureUploader
]

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> transparentTexture2D [
	^ transparentTexture2D
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

{ #category : #'private shaders' }
WDAGPUSceneRendererResourceCache >> unlitMaterialStateSource [
	^ '
layout(set=4, binding=0, std140) uniform MaterialStateBlock
{
	int doubleSided;
	float alphaCutoff;
	vec4 colorFactor;
} MaterialState;

layout(set=4, binding=1) uniform texture2D ColorTexture;
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
WDAGPUSceneRendererResourceCache >> validTextureViewHandleFor: aWDTexture [
	| textureHandle |
	textureHandle := self validTextureHandleFor: aWDTexture.
	^ { textureHandle getOrCreateFullView . textureHandle }
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

{ #category : #accessing }
WDAGPUSceneRendererResourceCache >> whiteTexture2D [
	^ whiteTexture2D
]
