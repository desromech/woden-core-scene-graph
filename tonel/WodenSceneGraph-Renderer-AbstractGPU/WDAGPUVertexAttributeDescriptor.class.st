"
I am a descriptor for a vertex attribute in a layout.
"
Class {
	#name : 'WDAGPUVertexAttributeDescriptor',
	#superclass : 'Object',
	#instVars : [
		'format',
		'binding',
		'buffer',
		'stride',
		'divisor'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Renderer',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Renderer'
}

{ #category : 'comparing' }
WDAGPUVertexAttributeDescriptor >> = other [
	^ self class == other class and: [
	format = other format and: [
	buffer = other buffer and: [
	stride = other stride and: [
	binding = other binding and: [
	divisor = other divisor ]]]]]
]

{ #category : 'converting' }
WDAGPUVertexAttributeDescriptor >> asAGPUVertexAttribDescriptionData [
	^ AGPUVertexAttribDescription new
		binding: binding;
		buffer: buffer;
		format: format;
		divisor: divisor;
		offset: 0;
		getHandle
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> binding [

	^ binding
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> binding: anObject [

	binding := anObject
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> buffer [

	^ buffer
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> buffer: anObject [

	buffer := anObject
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> divisor [

	^ divisor
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> divisor: anObject [

	divisor := anObject
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> format [

	^ format
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> format: anObject [

	format := anObject
]

{ #category : 'comparing' }
WDAGPUVertexAttributeDescriptor >> hash [
	^ (((format hash hashMultiply +
	buffer hash) hashMultiply +
	stride hash) hashMultiply +
	binding hash) hashMultiply +
	divisor hash
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> stride [

	^ stride
]

{ #category : 'accessing' }
WDAGPUVertexAttributeDescriptor >> stride: anObject [

	stride := anObject
]
