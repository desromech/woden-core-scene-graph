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

{ #category : #converting }
WDAGPUUniformBufferWriter class >> asWDAGPUUniformBufferWriter [
	^ self uniqueInstance
]

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
			| typeName arraySize typeDesc typeSize typeAlignment capitalizedTypeName writerName |
			arraySize := 1.
			fieldTypeDesc isArray ifTrue: [ 
				typeName := fieldTypeDesc first.		
				arraySize := fieldTypeDesc second.
			] ifFalse: [
				typeName := fieldTypeDesc
			].
		
			capitalizedTypeName := typeName first asUppercase asString , typeName allButFirst.
		
			Smalltalk globals at: typeName ifPresent: [:cls |
				typeSize := cls uniqueInstance instanceSize.
				typeAlignment := cls uniqueInstance instanceAlignment.
				capitalizedTypeName := 'Struct'.
				writerName := typeName.
			] ifAbsent: [ 
				typeDesc := TypeNameMap at: typeName.
				typeSize := typeDesc first.
				typeAlignment := typeDesc second.
			].

			instanceSize := instanceSize alignedTo: typeAlignment.
			out cr; tab;
				nextPutAll: 'self write'; nextPutAll: capitalizedTypeName; nextPutAll: ': data '; nextPutAll: fieldName.
			writerName ifNotNil: [ 
				out nextPutAll: ' writer: '; nextPutAll: writerName ; nextPutAll: ' uniqueInstance'
			].
			out nextPutAll: ' onto: pointer at: offset'.
			instanceSize > 0 ifTrue: [ 
				out nextPutAll: ' + ' ; print: instanceSize
			].
			arraySize > 1 ifTrue: [ 
				out nextPutAll: ' count: '; print: arraySize
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

		bool (4 4)

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

{ #category : #converting }
WDAGPUUniformBufferWriter >> asWDAGPUUniformBufferWriter [
	^ self
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> write: data onto: pointer at: offset [
	self subclassResponsibility
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeBool: data onto: pointer at: offset [
	pointer unsignedLongAt: offset + 1 put: data asBit
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeFloat: data onto: pointer at: offset [
	pointer floatAt: offset + 1 put: data asFloat
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeMat3: data onto: pointer at: offset [
	self halt
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeMat4: matrix onto: pointer at: offset [
	pointer
		floatAt: offset + 1 put: matrix m11 asFloat;
		floatAt: offset + 5 put: matrix m21 asFloat;
		floatAt: offset + 9 put: matrix m31 asFloat;
		floatAt: offset + 13 put: matrix m41 asFloat;
		
		floatAt: offset + 17 put: matrix m12 asFloat;
		floatAt: offset + 21 put: matrix m22 asFloat;
		floatAt: offset + 25 put: matrix m32 asFloat;
		floatAt: offset + 29 put: matrix m42 asFloat;

		floatAt: offset + 33 put: matrix m13 asFloat;
		floatAt: offset + 37 put: matrix m23 asFloat;
		floatAt: offset + 41 put: matrix m33 asFloat;
		floatAt: offset + 45 put: matrix m43 asFloat;

		floatAt: offset + 49 put: matrix m14 asFloat;
		floatAt: offset + 53 put: matrix m24 asFloat;
		floatAt: offset + 57 put: matrix m34 asFloat;
		floatAt: offset + 61 put: matrix m44 asFloat

]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeMat4: matrixArray onto: pointer at: offset count: count [
	| writeCount destOffset |
	writeCount := matrixArray size min: count.
	destOffset := offset.
	1 to: writeCount do: [ :i |
		self writeMat4: (matrixArray at: i) onto: pointer at: destOffset.
		destOffset := destOffset + 64
	]
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeStruct: data writer: structWriter onto: pointer at: offset count: count [
	| currentOffset elementSize writeCount |
	currentOffset := offset.
	elementSize := structWriter instanceSize.
	writeCount := data size min: count.
	1 to: writeCount do: [ :i |
		structWriter write: (data at: i) onto: pointer at: currentOffset.
		currentOffset := currentOffset + elementSize
	]
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeUint: data onto: pointer at: offset [
	pointer unsignedLongAt: offset + 1 put: data asInteger
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeUvec2: data onto: pointer at: offset [
	pointer
		unsignedLongAt: offset + 1 put: data x asInteger;
		unsignedLongAt: offset + 5 put: data y asInteger
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeUvec3: data onto: pointer at: offset [
	pointer
		unsignedLongAt: offset + 1 put: data x asInteger;
		unsignedLongAt: offset + 5 put: data y asInteger;
		unsignedLongAt: offset + 9 put: data z asInteger
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeVec2: data onto: pointer at: offset [
	pointer
		floatAt: offset + 1 put: data x asFloat;
		floatAt: offset + 5 put: data y asFloat
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeVec2: vectorArray onto: pointer at: offset count: count [
	| writeCount destOffset |
	writeCount := vectorArray size min: count.
	destOffset := offset.
	1 to: writeCount do: [ :i |
		self writeVec2: (vectorArray at: i) onto: pointer at: destOffset.
		destOffset := destOffset + 8
	]
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeVec3: data onto: pointer at: offset [
	pointer
		floatAt: offset + 1 put: data x asFloat;
		floatAt: offset + 5 put: data y asFloat;
		floatAt: offset + 9 put: data z asFloat
]

{ #category : #writing }
WDAGPUUniformBufferWriter >> writeVec4: data onto: pointer at: offset [
	pointer
		floatAt: offset + 1 put: data x asFloat;
		floatAt: offset + 5 put: data y asFloat;
		floatAt: offset + 9 put: data z asFloat;
		floatAt: offset + 13 put: data w asFloat
]
