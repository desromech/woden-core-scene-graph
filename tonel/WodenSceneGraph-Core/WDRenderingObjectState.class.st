"
I encapsulate the state for a generic rendering object.
"
Class {
	#name : #WDRenderingObjectState,
	#superclass : #Object,
	#instVars : [
		'transformation'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #initialization }
WDRenderingObjectState >> initialize [
	super initialize.
	transformation := ReversibleAffineTransform3D identity.
]

{ #category : #accessing }
WDRenderingObjectState >> transformation [

	^ transformation
]

{ #category : #accessing }
WDRenderingObjectState >> transformation: anObject [

	transformation := anObject
]
