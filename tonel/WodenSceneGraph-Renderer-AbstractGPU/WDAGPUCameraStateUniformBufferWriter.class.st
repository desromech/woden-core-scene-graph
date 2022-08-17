Class {
	#name : #WDAGPUCameraStateUniformBufferWriter,
	#superclass : #WDAGPUObjectStateUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUCameraStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		mat4 projectionMatrix

		float currentTime
		float exposure
		float nearDistance
		float farDistance

		uint lightGridColumns
		uint lightGridRows
		uint lightGridSlices
	)
]

{ #category : #accessing }
WDAGPUCameraStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUCameraStateUniformBufferWriter >> instanceSize [
	^ 224
]

{ #category : #writing }
WDAGPUCameraStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeMat4: data transformationMatrix onto: pointer at: offset.
	self writeMat4: data inverseTransformationMatrix onto: pointer at: offset + 64.
	self writeMat4: data projectionMatrix onto: pointer at: offset + 128.
	self writeFloat: data currentTime onto: pointer at: offset + 192.
	self writeFloat: data exposure onto: pointer at: offset + 196.
	self writeFloat: data nearDistance onto: pointer at: offset + 200.
	self writeFloat: data farDistance onto: pointer at: offset + 204.
	self writeUint: data lightGridColumns onto: pointer at: offset + 208.
	self writeUint: data lightGridRows onto: pointer at: offset + 212.
	self writeUint: data lightGridSlices onto: pointer at: offset + 216.
]
