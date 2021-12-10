Class {
	#name : #WDAGPUSurfaceMaterialUniformBufferWriter,
	#superclass : #WDAGPUMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUSurfaceMaterialUniformBufferWriter class >> fieldsDesc [
	^ #(
		bool doubleSided
		float effectiveAlphaCutoff
	)
]

{ #category : #testing }
WDAGPUSurfaceMaterialUniformBufferWriter class >> isAbstract [
	^ self == WDAGPUSurfaceMaterialUniformBufferWriter
]
