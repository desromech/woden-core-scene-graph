Class {
	#name : #WDAGPUMetallicRoughnessMaterialUniformBufferWriter,
	#superclass : #WDAGPUSurfaceMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		vec4 baseColorFactor
		vec4 emissiveFactor

		float occlusionFactor
		float roughnessFactor
		float metallicFactor
	)
]

{ #category : #accessing }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> instanceSize [
	^ 64
]

{ #category : #writing }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeBool: data doubleSided onto: pointer at: offset.
	self writeFloat: data alphaCutoff onto: pointer at: offset + 4.
	self writeVec4: data baseColorFactor onto: pointer at: offset + 16.
	self writeVec4: data emissiveFactor onto: pointer at: offset + 32.
	self writeFloat: data occlusionFactor onto: pointer at: offset + 48.
	self writeFloat: data roughnessFactor onto: pointer at: offset + 52.
	self writeFloat: data metallicFactor onto: pointer at: offset + 56.
]
