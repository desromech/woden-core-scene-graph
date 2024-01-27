Class {
	#name : #WDAGPUVolumetricDensityMaterialUniformBufferWriter,
	#superclass : #WDAGPUVolumetricMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUVolumetricDensityMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
	)
]

{ #category : #accessing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> instanceAlignment [
	^ 1
]

{ #category : #accessing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> instanceSize [
	^ 0
]

{ #category : #writing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
]
