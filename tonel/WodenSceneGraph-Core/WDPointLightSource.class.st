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
