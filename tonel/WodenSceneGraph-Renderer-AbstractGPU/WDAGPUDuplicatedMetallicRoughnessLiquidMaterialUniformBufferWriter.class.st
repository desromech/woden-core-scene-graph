Class {
	#name : 'WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter',
	#superclass : 'WDAGPUMetallicRoughnessMaterialUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		vec2 duplicatedTexcoordOffset
		vec2 duplicatedTexcoordScale
		vec2 duplicatedTexcoordOffsetVelocity
		float mixAlpha
	)
]

{ #category : 'accessing' }
WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : 'accessing' }
WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter >> instanceSize [
	^ 112
]

{ #category : 'writing' }
WDAGPUDuplicatedMetallicRoughnessLiquidMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
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
	self writeVec2: data duplicatedTexcoordOffset onto: pointer at: offset + 80.
	self writeVec2: data duplicatedTexcoordScale onto: pointer at: offset + 88.
	self writeVec2: data duplicatedTexcoordOffsetVelocity onto: pointer at: offset + 96.
	self writeFloat: data mixAlpha onto: pointer at: offset + 104.
]
