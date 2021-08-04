"
I am an object in a rendering scene.
"
Class {
	#name : #WDRenderingSceneObject,
	#superclass : #Object,
	#instVars : [
		'sortKey',
		'priority',
		'renderable'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderingSceneObject >> priority [

	^ priority
]

{ #category : #accessing }
WDRenderingSceneObject >> priority: anObject [

	priority := anObject
]

{ #category : #accessing }
WDRenderingSceneObject >> renderable [

	^ renderable
]

{ #category : #accessing }
WDRenderingSceneObject >> renderable: anObject [

	renderable := anObject
]

{ #category : #accessing }
WDRenderingSceneObject >> sortKey [

	^ sortKey
]

{ #category : #accessing }
WDRenderingSceneObject >> sortKey: anObject [

	sortKey := anObject
]
