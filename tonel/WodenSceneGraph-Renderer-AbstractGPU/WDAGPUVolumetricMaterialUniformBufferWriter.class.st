Class {
	#name : 'WDAGPUVolumetricMaterialUniformBufferWriter',
	#superclass : 'WDAGPUMaterialUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUVolumetricMaterialUniformBufferWriter class >> fieldsDesc [
	^ #()
]

{ #category : 'testing' }
WDAGPUVolumetricMaterialUniformBufferWriter class >> isAbstract [
	^ self == WDAGPUVolumetricMaterialUniformBufferWriter
]
