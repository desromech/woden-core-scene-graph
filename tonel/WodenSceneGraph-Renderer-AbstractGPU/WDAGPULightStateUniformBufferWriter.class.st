Class {
	#name : #WDAGPULightStateUniformBufferWriter,
	#superclass : #WDAGPUUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPULightStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ #(
		vec4 positionOrDirection

		vec3 intensity
		float influenceRadius

		vec3 spotDirection
		float innerSpotCosCutoff

		float outerSpotCosCutoff
		bool castShadows
	
		mat4 shadowMapTransformationMatrix
		mat4 shadowMapInverseTransformationMatrix

		mat4 shadowMapProjectionMatrix

		vec2 shadowMapViewportScale
		vec2 shadowMapViewportOffset
	)
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceSize [
	^ 272
]

{ #category : #writing }
WDAGPULightStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeVec4: data positionOrDirection onto: pointer at: offset.
	self writeVec3: data intensity onto: pointer at: offset + 16.
	self writeFloat: data influenceRadius onto: pointer at: offset + 28.
	self writeVec3: data spotDirection onto: pointer at: offset + 32.
	self writeFloat: data innerSpotCosCutoff onto: pointer at: offset + 44.
	self writeFloat: data outerSpotCosCutoff onto: pointer at: offset + 48.
	self writeBool: data castShadows onto: pointer at: offset + 52.
	self writeMat4: data shadowMapTransformationMatrix onto: pointer at: offset + 64.
	self writeMat4: data shadowMapInverseTransformationMatrix onto: pointer at: offset + 128.
	self writeMat4: data shadowMapProjectionMatrix onto: pointer at: offset + 192.
	self writeVec2: data shadowMapViewportScale onto: pointer at: offset + 256.
	self writeVec2: data shadowMapViewportOffset onto: pointer at: offset + 264.
]
