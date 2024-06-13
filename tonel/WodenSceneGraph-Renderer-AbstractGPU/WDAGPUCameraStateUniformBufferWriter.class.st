Class {
	#name : 'WDAGPUCameraStateUniformBufferWriter',
	#superclass : 'WDAGPUObjectStateUniformBufferWriter',
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Uniform',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Uniform'
}

{ #category : 'field definition' }
WDAGPUCameraStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		mat4 projectionMatrix
		mat4 inverseProjectionMatrix

		float currentTime
		float exposure
		float bloomThreshold
		float bloomStrength

		float nearDistance
		float farDistance
		
		vec2 framebufferExtent
		vec2 framebufferReciprocalExtent
		
		vec2 lightGridDepthSliceScaleOffset
		uint hasTopLeftNDCOrigin
		uint hasBottomLeftTextureCoordinates

		uvec3 lightGridExtent
		uint hasReverseDepth
	)
]

{ #category : 'accessing' }
WDAGPUCameraStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : 'accessing' }
WDAGPUCameraStateUniformBufferWriter >> instanceSize [
	^ 336
]

{ #category : 'writing' }
WDAGPUCameraStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeMat4: data transformationMatrix onto: pointer at: offset.
	self writeMat4: data inverseTransformationMatrix onto: pointer at: offset + 64.
	self writeMat4: data projectionMatrix onto: pointer at: offset + 128.
	self writeMat4: data inverseProjectionMatrix onto: pointer at: offset + 192.
	self writeFloat: data currentTime onto: pointer at: offset + 256.
	self writeFloat: data exposure onto: pointer at: offset + 260.
	self writeFloat: data bloomThreshold onto: pointer at: offset + 264.
	self writeFloat: data bloomStrength onto: pointer at: offset + 268.
	self writeFloat: data nearDistance onto: pointer at: offset + 272.
	self writeFloat: data farDistance onto: pointer at: offset + 276.
	self writeVec2: data framebufferExtent onto: pointer at: offset + 280.
	self writeVec2: data framebufferReciprocalExtent onto: pointer at: offset + 288.
	self writeVec2: data lightGridDepthSliceScaleOffset onto: pointer at: offset + 296.
	self writeUint: data hasTopLeftNDCOrigin onto: pointer at: offset + 304.
	self writeUint: data hasBottomLeftTextureCoordinates onto: pointer at: offset + 308.
	self writeUvec3: data lightGridExtent onto: pointer at: offset + 320.
	self writeUint: data hasReverseDepth onto: pointer at: offset + 332.
]
