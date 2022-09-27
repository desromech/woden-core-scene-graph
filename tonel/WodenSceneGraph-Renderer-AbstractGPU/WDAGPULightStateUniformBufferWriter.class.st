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
		vec2 shadowMapViewportScale
		
		float shadowMapNormalBiasFactor

		vec4 shadowMapCascadeDistanceWorldTransform
		vec4 shadowMapCascadeOffsets
		(vec2 6) shadowMapViewportOffsets
	
		(mat4 4) shadowMapTransformationMatrices
		(mat4 4) shadowMapInverseTransformationMatrices

		(mat4 4) shadowMapProjectionMatrices
	)
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPULightStateUniformBufferWriter >> instanceSize [
	^ 928
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
	self writeVec2: data shadowMapViewportScale onto: pointer at: offset + 56.
	self writeFloat: data shadowMapNormalBiasFactor onto: pointer at: offset + 64.
	self writeVec4: data shadowMapCascadeDistanceWorldTransform onto: pointer at: offset + 80.
	self writeVec4: data shadowMapCascadeOffsets onto: pointer at: offset + 96.
	self writeVec2: data shadowMapViewportOffsets onto: pointer at: offset + 112 count: 6.
	self writeMat4: data shadowMapTransformationMatrices onto: pointer at: offset + 160 count: 4.
	self writeMat4: data shadowMapInverseTransformationMatrices onto: pointer at: offset + 416 count: 4.
	self writeMat4: data shadowMapProjectionMatrices onto: pointer at: offset + 672 count: 4.
]
