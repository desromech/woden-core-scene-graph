Class {
	#name : 'WDSRWGLTF2BuilderNode',
	#superclass : 'Object',
	#instVars : [
		'index',
		'name',
		'children',
		'mesh',
		'transform',
		'light'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> children [

	^ children
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> children: anObject [

	children := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderNode >> encodeForJson [
	| nodeDict |
	nodeDict := OrderedDictionary new.
	name ifNotNil: [ 
		nodeDict at: 'name' put: name
	].
	mesh ifNotNil: [ 
		nodeDict at: 'mesh' put: mesh index.
	].

	light ifNotNil: [
		(nodeDict at: 'extensions' ifAbsentPut: [OrderedDictionary new])
			at: 'KHR_lights_punctual' put: (OrderedDictionary new
				at: 'light' put: light index;
				yourself)
	].

	transform ifNotNil: [
		nodeDict at: 'scale' put: {transform scale x. transform scale y. transform scale z}.
		nodeDict at: 'rotation' put: {transform rotation x. transform rotation y. transform rotation z. transform rotation w}.
		nodeDict at: 'translation' put: {transform translation x. transform translation y. transform translation z}.
	].

	children ifNotEmpty: [ 
		nodeDict at: 'children' put: (children collect: [:each | each index] as: Array )
	].
	^ nodeDict
	
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderNode >> initialize [
	children := #().
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> light [

	^ light
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> light: anObject [

	light := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> mesh [

	^ mesh
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> mesh: anObject [

	mesh := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> name [

	^ name
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> transform [

	^ transform
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderNode >> transform: aTransform [

	transform := aTransform asTRSTransform3D
]
