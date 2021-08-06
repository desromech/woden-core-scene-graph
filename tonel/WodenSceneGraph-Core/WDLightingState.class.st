Class {
	#name : #WDLightingState,
	#superclass : #Object,
	#instVars : [
		'ambientLighting',
		'lights'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDLightingState >> ambientLighting [

	^ ambientLighting
]

{ #category : #accessing }
WDLightingState >> ambientLighting: anObject [

	ambientLighting := anObject
]

{ #category : #initialization }
WDLightingState >> initialize [
	super initialize.
	ambientLighting := Vector3 zeros.
	lights := #().
]

{ #category : #accessing }
WDLightingState >> lights [

	^ lights
]

{ #category : #accessing }
WDLightingState >> lights: anObject [

	lights := anObject
]

{ #category : #'as yet unclassified' }
WDLightingState >> numberOfLights [
	^ lights size
]
