Class {
	#name : 'WDAGPUSurfaceMaterialUniformBufferWriter',
	#superclass : 'WDAGPUMaterialUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUSurfaceMaterialUniformBufferWriter class >> fieldsDesc [
	^ #(
		bool doubleSided
		float effectiveAlphaCutoff
	)
]

{ #category : 'testing' }
WDAGPUSurfaceMaterialUniformBufferWriter class >> isAbstract [
	^ self == WDAGPUSurfaceMaterialUniformBufferWriter
]
