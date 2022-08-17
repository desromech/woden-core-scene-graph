Class {
	#name : #WDAGPUShaderStackAllocator,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'capacity',
		'size',
		'bufferPointer'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Allocator'
}

{ #category : #'as yet unclassified' }
WDAGPUShaderStackAllocator class >> for: device capacity: capacity [
	^ self new initializeWithDevice: device capacity: capacity
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> allocate: allocationSize alignment: allocationAlignment [
	| offset newSize |
	offset := size alignedTo: allocationAlignment.
	newSize := offset + allocationSize.
	self assert: newSize <= capacity.
	size := newSize.
	
	^ WDAGPUShaderStackAllocation new
		allocator: self;
		offset: offset;
		size: allocationSize;
		yourself.
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> buffer [

	^ buffer
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> buffer: anObject [

	buffer := anObject
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> capacity [

	^ capacity
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> capacity: anObject [

	capacity := anObject
]

{ #category : #'initialize-release' }
WDAGPUShaderStackAllocator >> free [
	size := 0.
]

{ #category : #initialization }
WDAGPUShaderStackAllocator >> initializeWithDevice: aDevice capacity: initialCapacity [
	buffer := aDevice createBuffer: (AGPUBufferDescription new
		size: initialCapacity;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST;
		main_usage_mode: AGPU_COPY_SOURCE_BUFFER;
		usage_modes: AGPU_COPY_SOURCE_BUFFER;
		yourself) initial_data: nil.
	size := 0.
	capacity := initialCapacity.

]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> size [
	^ size
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> size: anObject [

	size := anObject
]

{ #category : #accessing }
WDAGPUShaderStackAllocator >> validBufferPointer [
	bufferPointer ifNotNil: [ ^ bufferPointer ].
	
	bufferPointer := buffer mapBuffer: AGPU_WRITE_ONLY.

	"We require here an ExternalAddress instead of an ExternalData. This check is required for runing Squeak."
	bufferPointer class == ExternalData ifTrue: [
		bufferPointer := bufferPointer getHandle
	].

	^ bufferPointer
]
