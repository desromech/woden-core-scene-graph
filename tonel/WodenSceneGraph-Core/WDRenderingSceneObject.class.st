"
I am an object in a rendering scene.
"
Class {
	#name : 'WDRenderingSceneObject',
	#superclass : 'Object',
	#instVars : [
		'sortKey',
		'priority',
		'objectState',
		'poseState',
		'renderable'
	],
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'accessing' }
WDRenderingSceneObject >> castShadows [
	^ objectState castShadows
]

{ #category : 'accessing' }
WDRenderingSceneObject >> objectState [

	^ objectState
]

{ #category : 'accessing' }
WDRenderingSceneObject >> objectState: anObject [

	objectState := anObject
]

{ #category : 'accessing' }
WDRenderingSceneObject >> poseState [

	^ poseState
]

{ #category : 'accessing' }
WDRenderingSceneObject >> poseState: anObject [

	poseState := anObject
]

{ #category : 'accessing' }
WDRenderingSceneObject >> priority [

	^ priority
]

{ #category : 'accessing' }
WDRenderingSceneObject >> priority: anObject [

	priority := anObject
]

{ #category : 'accessing' }
WDRenderingSceneObject >> renderable [

	^ renderable
]

{ #category : 'accessing' }
WDRenderingSceneObject >> renderable: anObject [

	renderable := anObject
]

{ #category : 'accessing' }
WDRenderingSceneObject >> sortKey [

	^ sortKey
]

{ #category : 'accessing' }
WDRenderingSceneObject >> sortKey: anObject [

	sortKey := anObject
]
