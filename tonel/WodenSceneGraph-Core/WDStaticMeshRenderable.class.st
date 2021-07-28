"
I am a renderable that holds a static mesh.
"
Class {
	#name : #WDStaticMeshRenderable,
	#superclass : #WDRenderable,
	#instVars : [
		'primitives'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}

{ #category : #initialization }
WDStaticMeshRenderable >> initialize [
	super initialize.
	primitives := #().
]

{ #category : #accessing }
WDStaticMeshRenderable >> primitives [

	^ primitives
]

{ #category : #accessing }
WDStaticMeshRenderable >> primitives: anObject [

	primitives := anObject
]
