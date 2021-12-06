"
I encapsulate a list of valid render priorities.
"
Class {
	#name : #WDRenderPriority,
	#superclass : #Object,
	#classVars : [
		'RenderPriorityBackgroundNoDepth',
		'RenderPriorityCount',
		'RenderPriorityDefault',
		'RenderPriorityOpaque',
		'RenderPriorityTranslucent'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderPriority class >> backgroundNoDepth [
	^ RenderPriorityBackgroundNoDepth
]

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
	RenderPriorityBackgroundNoDepth := 1.
	RenderPriorityOpaque := 2.
	RenderPriorityTranslucent := 3.
	RenderPriorityCount := 3.
	
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
