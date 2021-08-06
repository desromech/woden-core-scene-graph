Class {
	#name : #WDAGPULightStateUniformBufferWriter,
	#superclass : #WDAGPUUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPULightStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter. WDAGPULightingStateUniformBufferWriter generateWriter'>
	^ #(
		vec4 positionOrDirection
		vec3 intensity
		float influenceRadius

		vec3 spotDirection
		float innerSpotCosCutoff
		float outerSpotCosCutoff
	)
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceSize [
	^ 64
]

{ #category : #writing }
WDAGPULightStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeVec4: data positionOrDirection onto: pointer at: offset.
	self writeVec3: data intensity onto: pointer at: offset + 16.
	self writeFloat: data influenceRadius onto: pointer at: offset + 28.
	self writeVec3: data spotDirection onto: pointer at: offset + 32.
	self writeFloat: data innerSpotCosCutoff onto: pointer at: offset + 44.
	self writeFloat: data outerSpotCosCutoff onto: pointer at: offset + 48.
]
