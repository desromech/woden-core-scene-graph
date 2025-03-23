Class {
	#name : 'WDSRWGLTF2BuilderLight',
	#superclass : 'Object',
	#instVars : [
		'index',
		'color',
		'intensity',
		'type',
		'range',
		'innerConeAngle',
		'outerConeAngle'
	],
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> color [

	^ color
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> color: anObject [

	color := anObject
]

{ #category : 'initialization' }
WDSRWGLTF2BuilderLight >> encodeForJson [
	| bufferDict |
	bufferDict := OrderedDictionary new.
	bufferDict
		at: 'color' put: color;
		at: 'intensity' put: intensity;
		at: 'type' put: type.
	range ifNotNil: [ 
		bufferDict at: 'range' put: range
	].

	type = 'spot' ifTrue: [
		bufferDict at: 'spot' put: (OrderedDictionary new
			at: 'innerConeAngle' put: innerConeAngle;
			at: 'outerConeAngle' put: outerConeAngle;
			yourself)
	].
	
	^ bufferDict
	
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> index [

	^ index
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> innerConeAngle [

	^ innerConeAngle
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> innerConeAngle: anObject [

	innerConeAngle := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> intensity [

	^ intensity
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> intensity: anObject [

	intensity := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> outerConeAngle [

	^ outerConeAngle
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> outerConeAngle: anObject [

	outerConeAngle := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> range [

	^ range
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> range: anObject [

	range := anObject
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> type [

	^ type
]

{ #category : 'accessing' }
WDSRWGLTF2BuilderLight >> type: anObject [

	type := anObject
]
