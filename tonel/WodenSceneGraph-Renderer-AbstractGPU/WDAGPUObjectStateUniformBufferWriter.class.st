Class {
	#name : #WDAGPUObjectStateUniformBufferWriter,
	#superclass : #WDAGPUUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUObjectStateUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ #(
		mat4 transformationMatrix
		mat4 inverseTransformationMatrix
	)
]

{ #category : #accessing }
WDAGPUObjectStateUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUObjectStateUniformBufferWriter >> instanceSize [
	^ 128
]

{ #category : #writing }
WDAGPUObjectStateUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeMat4: data transformationMatrix onto: pointer at: offset.
	self writeMat4: data inverseTransformationMatrix onto: pointer at: offset + 64.
]
