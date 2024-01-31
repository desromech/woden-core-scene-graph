Class {
	#name : #WDAGPUVolumetricDensityMaterialUniformBufferWriter,
	#superclass : #WDAGPUVolumetricMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUVolumetricDensityMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		float minDensityThreshold
		float maxDensityThreshold

		float densityScale
		float densityBias
		
		float minTotalDensity
	)
]

{ #category : #accessing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> instanceAlignment [
	^ 4
]

{ #category : #accessing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> instanceSize [
	^ 20
]

{ #category : #writing }
WDAGPUVolumetricDensityMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeFloat: data minDensityThreshold onto: pointer at: offset.
	self writeFloat: data maxDensityThreshold onto: pointer at: offset + 4.
	self writeFloat: data densityScale onto: pointer at: offset + 8.
	self writeFloat: data densityBias onto: pointer at: offset + 12.
	self writeFloat: data minTotalDensity onto: pointer at: offset + 16.
]
