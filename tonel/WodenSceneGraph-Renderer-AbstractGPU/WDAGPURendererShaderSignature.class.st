"
I encapsulate the 3D renderer shader signature, and allocators for its different states.
"
Class {
	#name : #WDAGPURendererShaderSignature,
	#superclass : #Object,
	#instVars : [
		'device',
		'handle',
		'sampler',
		'samplersBinding',
		'cameraStateAllocator',
		'objectStateAllocator',
		'materialStateAllocator'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Resources'
}

{ #category : #'instance creation' }
WDAGPURendererShaderSignature class >> for: device [
	^ self basicNew initializeWithDevice: device
]

{ #category : #utility }
WDAGPURendererShaderSignature >> allocateCameraState [
	| result |
	result := cameraStateAllocator allocate.
	result bindingHandle ifNil: [ 
		result
			bindingHandle: (handle createShaderResourceBinding: 1);
			bindUniformBufferInSlot: 0.
	].
	^ result
]

{ #category : #utility }
WDAGPURendererShaderSignature >> allocateMaterialState [
	| result |
	result := materialStateAllocator allocate.
	result bindingHandle ifNil: [ 
		result
			bindingHandle: (handle createShaderResourceBinding: 4);
			bindUniformBufferInSlot: 0.
	].
	^ result
]

{ #category : #utility }
WDAGPURendererShaderSignature >> allocateObjectState [
	| result |
	result := objectStateAllocator allocate.
	result bindingHandle ifNil: [ 
		result
			bindingHandle: (handle createShaderResourceBinding: 3);
			bindUniformBufferInSlot: 0.
	].
	^ result
]

{ #category : #private }
WDAGPURendererShaderSignature >> buildHandle [
	handle := device createShaderSignatureBuilder
		beginBindingBank: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1;

		"Camera state"
		beginBindingBank: 100;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;

		"Lighting state"
		beginBindingBank: 100;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;

		"Object state"
		beginBindingBank: 100000;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;

		"Material state"
		beginBindingBank: 1000;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;
		"Layer 0"
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;

		"Layer 1"
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;

		build
]

{ #category : #private }
WDAGPURendererShaderSignature >> buildSamplersBinding [
	sampler := device createSampler: (AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 32.0;
		yourself).
		
	samplersBinding := handle createShaderResourceBinding: 0.
	samplersBinding bindSampler: 0 sampler: sampler.

]

{ #category : #accessing }
WDAGPURendererShaderSignature >> handle [
	^ handle
]

{ #category : #initialization }
WDAGPURendererShaderSignature >> initializeWithDevice: aDevice [
	device := aDevice.
	self
		buildHandle;
		buildSamplersBinding.
	cameraStateAllocator := WDAGPUShaderBindingResourceSlabAllocator for: device writers: { WDAGPUCameraStateUniformBufferWriter }.
	objectStateAllocator := WDAGPUShaderBindingResourceSlabAllocator for: device writers: { WDAGPUObjectStateUniformBufferWriter }.
	materialStateAllocator := WDAGPUShaderBindingResourceSlabAllocator for: device writers: WDAGPUMaterialUniformBufferWriter allSubclasses.
]

{ #category : #accessing }
WDAGPURendererShaderSignature >> samplersBinding [
	^ samplersBinding
]
