"
I am a model animation that can be attached to a node hierarchy.
"
Class {
	#name : #WDModelAnimation,
	#superclass : #Object,
	#instVars : [
		'name',
		'channels'
	],
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #accessing }
WDModelAnimation >> channels [

	^ channels
]

{ #category : #accessing }
WDModelAnimation >> channels: anObject [

	channels := anObject
]

{ #category : #accessing }
WDModelAnimation >> name [

	^ name
]

{ #category : #accessing }
WDModelAnimation >> name: anObject [

	name := anObject
]
