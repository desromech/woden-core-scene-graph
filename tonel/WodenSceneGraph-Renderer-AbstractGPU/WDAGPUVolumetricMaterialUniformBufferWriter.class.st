Class {
	#name : #WDAGPUVolumetricMaterialUniformBufferWriter,
	#superclass : #WDAGPUMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUVolumetricMaterialUniformBufferWriter class >> fieldsDesc [
	^ #()
]

{ #category : #testing }
WDAGPUVolumetricMaterialUniformBufferWriter class >> isAbstract [
	^ self == WDAGPUVolumetricMaterialUniformBufferWriter
]
