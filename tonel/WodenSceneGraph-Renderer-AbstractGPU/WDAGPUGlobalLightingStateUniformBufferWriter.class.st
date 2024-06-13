Class {
	#name : 'WDAGPUGlobalLightingStateUniformBufferWriter',
	#superclass : 'WDAGPUUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUGlobalLightingStateUniformBufferWriter class >> fieldsDesc [
	<script: 'WDAGPULightStateUniformBufferWriter generateWriter . self generateWriter'>
	^ #(
		vec3 ambientLighting
		uint numberOfLights
	)
]

{ #category : 'accessing' }
WDAGPUGlobalLightingStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : 'accessing' }
WDAGPUGlobalLightingStateUniformBufferWriter >> instanceSize [
	^ 16
]

{ #category : 'writing' }
WDAGPUGlobalLightingStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeVec3: data ambientLighting onto: pointer at: offset.
	self writeUint: data numberOfLights onto: pointer at: offset + 12.
]
