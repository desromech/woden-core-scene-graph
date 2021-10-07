"
I hold the global per-scene lighting state. I hold the following parameters:
- ambientLighting factor.

"
Class {
	#name : #WDGlobalLightingState,
	#superclass : #Object,
	#instVars : [
		'ambientLighting'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #'as yet unclassified' }
WDGlobalLightingState class >> default [
	^ self new
		ambientLighting: (Vector3 withAll: 0.2);
		yourself
]

{ #category : #'as yet unclassified' }
WDGlobalLightingState class >> defaultForInspector [
	^ self default
]

{ #category : #accessing }
WDGlobalLightingState >> ambientLighting [

	^ ambientLighting
]

{ #category : #accessing }
WDGlobalLightingState >> ambientLighting: anObject [

	ambientLighting := anObject
]

{ #category : #'as yet unclassified' }
WDGlobalLightingState >> globalLightingState: other [
	ambientLighting := other ambientLighting.
]

{ #category : #initialization }
WDGlobalLightingState >> initialize [
	super initialize.
	ambientLighting := Vector3 zeros.
]
