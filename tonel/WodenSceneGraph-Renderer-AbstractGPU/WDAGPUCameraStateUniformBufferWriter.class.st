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
	)
]

{ #category : #accessing }
WDAGPUCameraStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUCameraStateUniformBufferWriter >> instanceSize [
	^ 208
]

{ #category : #writing }
WDAGPUCameraStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeMat4: data transformationMatrix onto: pointer at: offset.
	self writeMat4: data inverseTransformationMatrix onto: pointer at: offset + 64.
	self writeMat4: data projectionMatrix onto: pointer at: offset + 128.
	self writeFloat: data currentTime onto: pointer at: offset + 192.
	self writeFloat: data exposure onto: pointer at: offset + 196.
]
