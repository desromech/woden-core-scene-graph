"
I hold the ray casting result for a specific collision shape.
"
Class {
	#name : 'WDShapeRayCastingResult',
	#superclass : 'Object',
	#instVars : [
		'shape',
		'distance',
		'normal'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'accessing' }
WDShapeRayCastingResult >> distance [

	^ distance
]

{ #category : 'accessing' }
WDShapeRayCastingResult >> distance: anObject [

	distance := anObject
]

{ #category : 'accessing' }
WDShapeRayCastingResult >> normal [

	^ normal
]

{ #category : 'accessing' }
WDShapeRayCastingResult >> normal: anObject [

	normal := anObject
]

{ #category : 'accessing' }
WDShapeRayCastingResult >> shape [

	^ shape
]

{ #category : 'accessing' }
WDShapeRayCastingResult >> shape: anObject [

	shape := anObject
]
