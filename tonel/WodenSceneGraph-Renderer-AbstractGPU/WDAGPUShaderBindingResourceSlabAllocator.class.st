"
I am a slab based allocator for shader resource uniform buffer binding.
"
Class {
	#name : 'WDAGPUShaderBindingResourceSlabAllocator',
	#superclass : 'Object',
	#instVars : [
		'device',
		'elementSize',
		'elementAlignment',
		'currentBlock',
		'freeList',
		'hasPersistentMapping'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Allocator',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Allocator'
}

{ #category : 'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocator class >> for: device writers: writers [
	^ self basicNew initializeWithDevice: device writers: writers
]

{ #category : 'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocator >> allocate [
	| result |
	freeList ifNotNil: [ 
		result := freeList.
		freeList := freeList nextFree.
		result nextFree: nil.
		^ result
	].

	(currentBlock isNil or: [currentBlock isFull]) ifTrue: [
		currentBlock := WDAGPUShaderBindingResourceSlabAllocatorBlock for: self
	].
	^ currentBlock allocate
]

{ #category : 'accessing' }
WDAGPUShaderBindingResourceSlabAllocator >> device [

	^ device
]

{ #category : 'accessing' }
WDAGPUShaderBindingResourceSlabAllocator >> elementAlignment [

	^ elementAlignment
]

{ #category : 'accessing' }
WDAGPUShaderBindingResourceSlabAllocator >> elementSize [

	^ elementSize
]

{ #category : 'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocator >> freeAllocation: allocation [
	self assert: allocation nextFree isNil.
	allocation nextFree: freeList.
	freeList := allocation
]

{ #category : 'accessing' }
WDAGPUShaderBindingResourceSlabAllocator >> hasPersistentMapping [
	^ hasPersistentMapping
]

{ #category : 'initialization' }
WDAGPUShaderBindingResourceSlabAllocator >> initializeWithDevice: aDevice writers: aListOfWriters [
	device := aDevice.
	elementSize := 0.
	elementAlignment := 1.
	aListOfWriters do: [ :each |
		each isAbstract ifFalse: [
			elementSize := elementSize max: each uniqueInstance instanceSize.
			elementAlignment := elementAlignment max: each uniqueInstance instanceAlignment.
		]
	].

	elementAlignment := elementAlignment max: 256.
	elementSize := elementSize alignedTo: elementAlignment.
	hasPersistentMapping := (device isFeatureSupported: AGPU_FEATURE_PERSISTENT_COHERENT_MEMORY_MAPPING) ~= 0.
]
