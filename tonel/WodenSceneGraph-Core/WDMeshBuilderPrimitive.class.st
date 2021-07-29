"
I am a mesh primitive that is being built by a mesh builder.
"
Class {
	#name : #WDMeshBuilderPrimitive,
	#superclass : #Object,
	#instVars : [
		'topology',
		'material',
		'firstIndex',
		'indexCount'
	],
	#category : #'WodenSceneGraph-Core-RenderableBuilder'
}

{ #category : #accessing }
WDMeshBuilderPrimitive >> firstIndex [

	^ firstIndex
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> firstIndex: anObject [

	firstIndex := anObject
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> indexCount [

	^ indexCount
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> indexCount: anObject [

	indexCount := anObject
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> material [

	^ material
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> topology [

	^ topology
]

{ #category : #accessing }
WDMeshBuilderPrimitive >> topology: anObject [

	topology := anObject
]
