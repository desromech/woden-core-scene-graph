Class {
	#name : #WDCompoundCollisionShapeComponent,
	#superclass : #Object,
	#instVars : [
		'shape',
		'transform',
		'boundingBox'
	],
	#category : #'WodenSceneGraph-Core-Collision'
}

{ #category : #accessing }
WDCompoundCollisionShapeComponent >> boundingBox [
	^ boundingBox ifNil: [boundingBox := shape localBoundingBoxWithMargin transformedWith: transform]
]

{ #category : #accessing }
WDCompoundCollisionShapeComponent >> shape [

	^ shape
]

{ #category : #accessing }
WDCompoundCollisionShapeComponent >> shape: anObject [

	shape := anObject
]

{ #category : #accessing }
WDCompoundCollisionShapeComponent >> transform [

	^ transform
]

{ #category : #accessing }
WDCompoundCollisionShapeComponent >> transform: anObject [

	transform := anObject
]
