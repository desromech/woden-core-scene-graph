"
I hold a handle and the data required for retrieving and updating a renderer specific cached resource.
"
Class {
	#name : 'WDAGPUSceneRendererCachedResource',
	#superclass : 'Object',
	#instVars : [
		'description',
		'modificationCount',
		'handle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Resources',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Resources'
}

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> description [

	^ description
]

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> handle [

	^ handle
]

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> handle: anObject [

	handle := anObject
]

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> modificationCount [

	^ modificationCount
]

{ #category : 'accessing' }
WDAGPUSceneRendererCachedResource >> modificationCount: anObject [

	modificationCount := anObject
]
