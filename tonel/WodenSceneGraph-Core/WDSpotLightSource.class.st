"
I am a punctual light source that directs its light into a cone.

"
Class {
	#name : #WDSpotLightSource,
	#superclass : #WDPointLightSource,
	#instVars : [
		'innerCutoff',
		'outerCutoff'
	],
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #converting }
WDSpotLightSource >> asLightStateWithTransform: renderingTransform [
	^ (super asLightStateWithTransform: renderingTransform)
		spotDirection: renderingTransform matrix thirdColumn;
		innerSpotCosCutoff: innerCutoff degreeCos;
		outerSpotCosCutoff: outerCutoff degreeCos;
		yourself.
]

{ #category : #initialization }
WDSpotLightSource >> initialize [
	super initialize.
	innerCutoff := 45.0.
	outerCutoff := 60.0.
]

{ #category : #accessing }
WDSpotLightSource >> innerCutoff [

	^ innerCutoff
]

{ #category : #accessing }
WDSpotLightSource >> innerCutoff: anObject [

	innerCutoff := anObject
]

{ #category : #accessing }
WDSpotLightSource >> outerCutoff [

	^ outerCutoff
]

{ #category : #accessing }
WDSpotLightSource >> outerCutoff: anObject [

	outerCutoff := anObject
]
