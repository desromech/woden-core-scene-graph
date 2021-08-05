"
I am an utility for writing uniform buffer data. My instances are completely stateless, so they are a singleton.
"
Class {
	#name : #WDAGPUUniformBufferWriter,
	#superclass : #Object,
	#classVars : [
		'TypeNameMap'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #'field definition' }
WDAGPUUniformBufferWriter class >> fieldsDesc [
	self subclassResponsibility
]

{ #category : #'field definition' }
WDAGPUUniformBufferWriter class >> generateWriter [
	| writerSourceCode instanceSize instanceAlignment |
	instanceSize := 0.
	instanceAlignment := 1.
	writerSourceCode := ByteString streamContents: [ :out |
		out nextPutAll: 'write: data onto: pointer at: offset'.
		
		self fieldsDesc pairsDo: [ :fieldTypeDesc :fieldName |
			| typeName arraySize typeDesc typeSize typeAlignment capitalizedTypeName |
			arraySize := 1.
			fieldTypeDesc isArray ifTrue: [ 
				typeName := fieldTypeDesc name.		
				arraySize := fieldTypeDesc second.
			] ifFalse: [
				typeName := fieldTypeDesc
			].
		
			capitalizedTypeName := typeName first asUppercase asString , typeName allButFirst.
		
			typeDesc := TypeNameMap at: typeName.
			typeSize := typeDesc first.
			typeAlignment := typeDesc second.

			instanceSize := instanceSize alignedTo: typeAlignment.
			out cr; tab;
				nextPutAll: 'self write'; nextPutAll: capitalizedTypeName; nextPutAll: ': data '; nextPutAll: fieldName;
				nextPutAll: ' onto: pointer at: offset'.
			instanceSize > 0 ifTrue: [ 
				out nextPutAll: ' + ' ; print: instanceSize
			].
			out nextPut: $..
			
			instanceAlignment := instanceAlignment max: typeAlignment.
			instanceSize := instanceSize + (typeSize*arraySize).
		].
	].

	instanceSize := instanceSize alignedTo: instanceAlignment.
	self compile: writerSourceCode classified: 'writing'.
	self compile: (ByteString streamContents: [:out |
		out nextPutAll: 'instanceSize'; cr; tab; nextPutAll: '^ '; print: instanceSize
	]) classified: 'accessing'.
	self compile: (ByteString streamContents: [:out |
		out nextPutAll: 'instanceAlignment'; cr; tab; nextPutAll: '^ '; print: instanceAlignment
	]) classified: 'accessing'.

]

{ #category : #initialization }
WDAGPUUniformBufferWriter class >> initialize [
	TypeNameMap := Dictionary newFromPairs: #(
		"Type name (size alignment)"
		float (4 4)
		vec2 (8 8)
		vec3 (12 16)
		vec4 (16 16)

		mat4 (64 16)
		mat3 (48 16)

		uint (4 4)
		uvec2 (8 8)
		uvec3 (12 16)
		uvec4 (16 16)

		int (4 4)
		ivec2 (8 8)
		ivec3 (12 16)
		ivec4 (16 16)
	)
]

{ #category : #testing }
WDAGPUUniformBufferWriter class >> isAbstract [
	^ self == WDAGPUUniformBufferWriter
]

{ #category : #'instance creation' }
WDAGPUUniformBufferWriter class >> new [
	self error: 'New cannot be used here.'
]

{ #category : #accessing }
WDAGPUUniformBufferWriter class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> write: data onto: pointer at: offset [
	self subclassResponsibility
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeFloat: data onto: pointer at: offset [
	self halt
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeMat3: data onto: pointer at: offset [
	self halt
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeMat4: data onto: pointer at: offset [
	self halt
]
