"
I hold the full per-scene lighting state. I am a combination of a global lighting state, and a set of different lights.
"
Class {
	#name : 'WDLightingState',
	#superclass : 'WDGlobalLightingState',
	#instVars : [
		'lights'
	],
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'initialization' }
WDLightingState >> initialize [
	super initialize.
	lights := #().
]

{ #category : 'accessing' }
WDLightingState >> lights [

	^ lights
]

{ #category : 'accessing' }
WDLightingState >> lights: anObject [

	lights := anObject
]

{ #category : 'accessing' }
WDLightingState >> numberOfLights [
	^ lights size
]
