Class {
	#name : 'WDAGPUShaderStackAllocation',
	#superclass : 'Object',
	#instVars : [
		'allocator',
		'offset',
		'size'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Allocator',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Allocator'
}

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> allocator [

	^ allocator
]

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> allocator: anObject [

	allocator := anObject
]

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> offset [

	^ offset
]

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> offset: anObject [

	offset := anObject
]

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> size [

	^ size
]

{ #category : 'accessing' }
WDAGPUShaderStackAllocation >> size: anObject [

	size := anObject
]

{ #category : 'writing' }
WDAGPUShaderStackAllocation >> writeValue: value with: uniformWriterOrItsClass at: valueOffset [
	uniformWriterOrItsClass asWDAGPUUniformBufferWriter
		write: value onto: allocator validBufferPointer at: offset + valueOffset
]
