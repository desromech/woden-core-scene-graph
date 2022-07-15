"
I hold a uniform buffer block which is suballocated.
"
Class {
	#name : #WDAGPUShaderBindingResourceSlabAllocatorBlock,
	#superclass : #Object,
	#instVars : [
		'allocator',
		'buffer',
		'capacity',
		'size',
		'elementSize',
		'bufferPointer'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Allocator'
}

{ #category : #'instance creation' }
WDAGPUShaderBindingResourceSlabAllocatorBlock class >> for: anAllocator [
	^ self basicNew initializeWithAllocator: anAllocator
]

{ #category : #'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> allocate [
	| result |
	self assert: self isFull not.
	result := WDAGPUShaderBindingResourceSlabAllocation new
		block: self;
		offset: size;
		yourself.
	size := size + elementSize.
	^ result
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> allocator [

	^ allocator
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> buffer [

	^ buffer
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> capacity [

	^ capacity
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> elementSize [
	^ elementSize
]

{ #category : #initialization }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> initializeWithAllocator: anAllocator [
	| mappingFlags |
	allocator := anAllocator.
	elementSize := allocator elementSize.

	"Use 1MB blocks."
	capacity := 1*1024*1024.
	size := 0.
	mappingFlags := AGPU_MAP_WRITE_BIT.
	allocator hasPersistentMapping ifTrue: [
		mappingFlags := (mappingFlags bitOr: AGPU_MAP_PERSISTENT_BIT) bitOr: AGPU_MAP_COHERENT_BIT
	].
	
	buffer := anAllocator device createBuffer: (AGPUBufferDescription new
		size: capacity;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		usage_modes: AGPU_UNIFORM_BUFFER;
		main_usage_mode: AGPU_UNIFORM_BUFFER;
		mapping_flags: mappingFlags;
		yourself		
		) initial_data: nil
]

{ #category : #testing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> isFull [
	^ size + elementSize >= capacity
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> size [
	^ size
]

{ #category : #accessing }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> size: anObject [

	size := anObject
]

{ #category : #'as yet unclassified' }
WDAGPUShaderBindingResourceSlabAllocatorBlock >> validBufferPointer [
	bufferPointer ifNotNil: [ ^ bufferPointer ].
	
	bufferPointer := buffer mapBuffer: AGPU_WRITE_ONLY.

	"We require here an ExternalAddress instead of an ExternalData. This check is required for runing Squeak."
	bufferPointer class == ExternalData ifTrue: [
		bufferPointer := bufferPointer getHandle
	].

	allocator hasPersistentMapping ifFalse: [ 
		self halt
	].

	^ bufferPointer
]
