Class {
	#name : 'WDAGPUMetallicRoughnessMaterialUniformBufferWriter',
	#superclass : 'WDAGPUSurfaceMaterialUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		vec4 baseColorFactor
		vec3 emissiveFactor

		float occlusionFactor
		float roughnessFactor
		float metallicFactor
		
		vec2 texcoordOffset
		vec2 texcoordScale
		vec2 texcoordOffsetVelocity
	)
]

{ #category : 'accessing' }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : 'accessing' }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> instanceSize [
	^ 80
]

{ #category : 'writing' }
WDAGPUMetallicRoughnessMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeBool: data doubleSided onto: pointer at: offset.
	self writeFloat: data effectiveAlphaCutoff onto: pointer at: offset + 4.
	self writeVec4: data baseColorFactor onto: pointer at: offset + 16.
	self writeVec3: data emissiveFactor onto: pointer at: offset + 32.
	self writeFloat: data occlusionFactor onto: pointer at: offset + 44.
	self writeFloat: data roughnessFactor onto: pointer at: offset + 48.
	self writeFloat: data metallicFactor onto: pointer at: offset + 52.
	self writeVec2: data texcoordOffset onto: pointer at: offset + 56.
	self writeVec2: data texcoordScale onto: pointer at: offset + 64.
	self writeVec2: data texcoordOffsetVelocity onto: pointer at: offset + 72.
]
