"
I encapsulate a list of valid render priorities.
"
Class {
	#name : #WDRenderPriority,
	#superclass : #Object,
	#classVars : [
		'RenderPriorityCount',
		'RenderPriorityDefault',
		'RenderPriorityOpaque',
		'RenderPriorityTranslucent'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderPriority class >> count [
	^ RenderPriorityCount
]

{ #category : #accessing }
WDRenderPriority class >> default [
	^ RenderPriorityDefault
]

{ #category : #initialization }
WDRenderPriority class >> initialize [
	RenderPriorityOpaque := 1.
	RenderPriorityTranslucent := 2.
	RenderPriorityCount := 2.
	
	RenderPriorityDefault := RenderPriorityOpaque.
]

{ #category : #accessing }
WDRenderPriority class >> opaque [
	^ RenderPriorityOpaque
]

{ #category : #accessing }
WDRenderPriority class >> translucent [
	^ RenderPriorityTranslucent
]
