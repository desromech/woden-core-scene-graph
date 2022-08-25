"
I am a punctual light source.

I have a specific influence radius that constraints the locations that are affected by me.
"
Class {
	#name : #WDPointLightSource,
	#superclass : #WDLightSource,
	#instVars : [
		'influenceRadius'
	],
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #converting }
WDPointLightSource >> asLightStateWithTransform: renderingTransform [
	^ WDLightState new
		positionOrDirection: (Vector4 xyz: renderingTransform translation w: 1.0);
		influenceRadius: influenceRadius;
		intensity: intensity;
		yourself.
]

{ #category : #accessing }
WDPointLightSource >> boundingBox [
	^ AABox halfExtent: influenceRadius asVector3
]

{ #category : #accessing }
WDPointLightSource >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDPointLightSource >> influenceRadius: anObject [

	influenceRadius := anObject
]

{ #category : #initialization }
WDPointLightSource >> initialize [
	super initialize.
	influenceRadius := 1.0.
]
