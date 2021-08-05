Class {
	#name : #WDAGPUShaderBindingResourceSlabAllocation,
	#superclass : #Object,
	#instVars : [
		'bindingHandle',
		'offset',
		'block',
		'nextFree'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Allocator'
}

{ #category : #'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocation >> bindUniformBufferInSlot: slotIndex [
	bindingHandle bindUniformBufferRange: slotIndex uniform_buffer: block buffer offset: offset size: block elementSize
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> bindingHandle [

	^ bindingHandle
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> bindingHandle: anObject [

	bindingHandle := anObject
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> block [

	^ block
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> block: anObject [

	block := anObject
]

{ #category : #'initialize-release' }
WDAGPUShaderBindingResourceSlabAllocation >> free [
	block allocator freeAllocation: self
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> nextFree [

	^ nextFree
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> nextFree: anObject [

	nextFree := anObject
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> offset [

	^ offset
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocation >> offset: anObject [

	offset := anObject
]

{ #category : #writing }
WDAGPUShaderBindingResourceSlabAllocation >> writeState: state with: uniformWriterOrItsClass [
	uniformWriterOrItsClass asWDAGPUUniformBufferWriter
		write: state onto: block validBufferPointer at: offset
]
