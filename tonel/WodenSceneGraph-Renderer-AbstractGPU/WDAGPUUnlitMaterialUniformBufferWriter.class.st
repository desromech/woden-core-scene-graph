Class {
	#name : #WDAGPUUnlitMaterialUniformBufferWriter,
	#superclass : #WDAGPUSurfaceMaterialUniformBufferWriter,
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUUnlitMaterialUniformBufferWriter class >> fieldsDesc [
	<script: 'self generateWriter'>
	^ super fieldsDesc , #(
		vec4 colorFactor
	)
]

{ #category : #accessing }
WDAGPUUnlitMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUUnlitMaterialUniformBufferWriter >> instanceSize [
	^ 32
]

{ #category : #writing }
WDAGPUUnlitMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeBool: data doubleSided onto: pointer at: offset.
	self writeFloat: data alphaCutoff onto: pointer at: offset + 4.
	self writeVec4: data colorFactor onto: pointer at: offset + 16.
]
