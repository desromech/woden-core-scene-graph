Class {
	#name : #WDAGPULightingStateUniformBufferWriter,
	#superclass : #WDAGPUUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPULightingStateUniformBufferWriter class >> fieldsDesc [
	<script: 'WDAGPULightStateUniformBufferWriter generateWriter . self generateWriter'>
	^ #(
		vec3 ambientLighting
		uint numberOfLights
		(WDAGPULightStateUniformBufferWriter 8) lights
	)
]

{ #category : #accessing }
WDAGPULightingStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPULightingStateUniformBufferWriter >> instanceSize [
	^ 528
]

{ #category : #writing }
WDAGPULightingStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeVec3: data ambientLighting onto: pointer at: offset.
	self writeUint: data numberOfLights onto: pointer at: offset + 12.
	self writeStruct: data lights writer: WDAGPULightStateUniformBufferWriter uniqueInstance onto: pointer at: offset + 16 count: 8.
]
