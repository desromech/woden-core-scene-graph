Class {
	#name : #WDAGPUPoseStateUniformBufferWriter,
	#superclass : #WDAGPUUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUPoseStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ #(
		(mat4 256) skinningMatrices
	)
]

{ #category : #accessing }
WDAGPUPoseStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUPoseStateUniformBufferWriter >> instanceSize [
	^ 16384
]

{ #category : #writing }
WDAGPUPoseStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeMat4: data skinningMatrices onto: pointer at: offset count: 256.
]
