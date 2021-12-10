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
		
		vec2 texcoordOffset
		vec2 texcoordScale
		vec2 texcoordOffsetVelocity
	)
]

{ #category : #accessing }
WDAGPUUnlitMaterialUniformBufferWriter >> instanceAlignment [
	^ 16
]

{ #category : #accessing }
WDAGPUUnlitMaterialUniformBufferWriter >> instanceSize [
	^ 64
]

{ #category : #writing }
WDAGPUUnlitMaterialUniformBufferWriter >> write: data onto: pointer at: offset [
	self writeBool: data doubleSided onto: pointer at: offset.
	self writeFloat: data effectiveAlphaCutoff onto: pointer at: offset + 4.
	self writeVec4: data colorFactor onto: pointer at: offset + 16.
	self writeVec2: data texcoordOffset onto: pointer at: offset + 32.
	self writeVec2: data texcoordScale onto: pointer at: offset + 40.
	self writeVec2: data texcoordOffsetVelocity onto: pointer at: offset + 48.
]
