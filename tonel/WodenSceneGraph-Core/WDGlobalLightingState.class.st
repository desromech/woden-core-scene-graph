"
I hold the global per-scene lighting state. I hold the following parameters:
- ambientLighting factor.

"
Class {
	#name : 'WDGlobalLightingState',
	#superclass : 'Object',
	#instVars : [
		'ambientLighting',
		'ambientLightProbe'
	],
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'as yet unclassified' }
WDGlobalLightingState class >> default [
	^ self new
		ambientLighting: (Vector3 withAll: 0.2);
		yourself
]

{ #category : 'as yet unclassified' }
WDGlobalLightingState class >> defaultForInspector [
	^ self default
]

{ #category : 'as yet unclassified' }
WDGlobalLightingState >> ambientDiffuseLightProbeTexture [
	^ ambientLightProbe ifNotNil: [ ambientLightProbe diffuse ]
]

{ #category : 'accessing' }
WDGlobalLightingState >> ambientLightProbe [
	^ ambientLightProbe
]

{ #category : 'accessing' }
WDGlobalLightingState >> ambientLightProbe: aWDLightProbe [
	ambientLightProbe := aWDLightProbe
]

{ #category : 'accessing' }
WDGlobalLightingState >> ambientLighting [

	^ ambientLighting
]

{ #category : 'accessing' }
WDGlobalLightingState >> ambientLighting: anAmbientLightingFactor [
	ambientLighting := anAmbientLightingFactor asVector3
]

{ #category : 'as yet unclassified' }
WDGlobalLightingState >> ambientSpecularLightProbeTexture [
	^ ambientLightProbe ifNotNil: [ ambientLightProbe specular ]
]

{ #category : 'as yet unclassified' }
WDGlobalLightingState >> globalLightingState: other [
	ambientLighting := other ambientLighting.
	ambientLightProbe := other ambientLightProbe.
]

{ #category : 'initialization' }
WDGlobalLightingState >> initialize [
	super initialize.
	ambientLighting := Vector3 zeros.
]
