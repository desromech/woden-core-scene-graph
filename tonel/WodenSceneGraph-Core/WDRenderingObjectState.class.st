"
I encapsulate the state for a generic rendering object.
"
Class {
	#name : 'WDRenderingObjectState',
	#superclass : 'Object',
	#instVars : [
		'transformation',
		'castShadows'
	],
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'accessing' }
WDRenderingObjectState >> castShadows [

	^ castShadows
]

{ #category : 'accessing' }
WDRenderingObjectState >> castShadows: anObject [

	castShadows := anObject
]

{ #category : 'initialization' }
WDRenderingObjectState >> initialize [
	super initialize.
	transformation := ReversibleAffineTransform3D identity.
]

{ #category : 'accessing' }
WDRenderingObjectState >> inverseTransformationMatrix [
	^ transformation inverseMatrix4
]

{ #category : 'accessing' }
WDRenderingObjectState >> transformation [

	^ transformation
]

{ #category : 'accessing' }
WDRenderingObjectState >> transformation: anObject [

	transformation := anObject
]

{ #category : 'accessing' }
WDRenderingObjectState >> transformationMatrix [
	^ transformation matrix4
]
