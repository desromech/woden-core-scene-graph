Class {
	#name : 'WDAGPUEnvironmentMapMaterialUniformBufferWriter',
	#superclass : 'WDAGPUSurfaceMaterialUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUEnvironmentMapMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		vec4 colorFactor
	)
]

{ #category : 'accessing' }
WDAGPUEnvironmentMapMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : 'accessing' }
WDAGPUEnvironmentMapMaterialUniformBufferWriter >> instanceSize [
	^ 32
]

{ #category : 'writing' }
WDAGPUEnvironmentMapMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeBool: data doubleSided onto: pointer at: offset.
	self writeFloat: data effectiveAlphaCutoff onto: pointer at: offset + 4.
	self writeVec4: data colorFactor onto: pointer at: offset + 16.
]
