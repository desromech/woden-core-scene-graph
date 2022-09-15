"
I encapsulate the rendering state for a specific light.
"
Class {
	#name : #WDLightState,
	#superclass : #Object,
	#instVars : [
		'positionOrDirection',
		'intensity',
		'spotDirection',
		'innerSpotCosCutoff',
		'outerSpotCosCutoff',
		'influenceRadius',
		'castShadows',
		'shadowMappingCameraStates',
		'shadowMapViewportScale',
		'shadowMapViewportOffsets',
		'shadowMapProjectionMatrices',
		'shadowMapCascadeDistanceWorldTransform',
		'shadowMapCascadeOffsets'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #requirements }
WDLightState class >> empty [
	^ self new
]

{ #category : #accessing }
WDLightState >> castShadows [

	^ castShadows
]

{ #category : #accessing }
WDLightState >> castShadows: anObject [

	castShadows := anObject
]

{ #category : #accessing }
WDLightState >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDLightState >> influenceRadius: anObject [

	influenceRadius := anObject
]

{ #category : #initialization }
WDLightState >> initialize [
	positionOrDirection := Vector4 zeros.
	intensity := Vector3 zeros.
	spotDirection := Vector3 zeros.
	innerSpotCosCutoff := -1.0.
	outerSpotCosCutoff := -1.0.
	influenceRadius := 1.0.
	castShadows := false.
	shadowMappingCameraStates := #().
	shadowMapCascadeDistanceWorldTransform := Vector4 zeros.
	shadowMapCascadeOffsets := Vector4 zeros.
	
	shadowMapViewportScale := Vector2 x: 0.5 y: 0.5.
	shadowMapViewportOffsets := #().
]

{ #category : #accessing }
WDLightState >> innerSpotCosCutoff [

	^ innerSpotCosCutoff
]

{ #category : #accessing }
WDLightState >> innerSpotCosCutoff: anObject [

	innerSpotCosCutoff := anObject
]

{ #category : #accessing }
WDLightState >> intensity [

	^ intensity
]

{ #category : #accessing }
WDLightState >> intensity: anObject [

	intensity := anObject
]

{ #category : #accessing }
WDLightState >> outerSpotCosCutoff [

	^ outerSpotCosCutoff
]

{ #category : #accessing }
WDLightState >> outerSpotCosCutoff: anObject [

	outerSpotCosCutoff := anObject
]

{ #category : #accessing }
WDLightState >> positionOrDirection [

	^ positionOrDirection
]

{ #category : #accessing }
WDLightState >> positionOrDirection: anObject [

	positionOrDirection := anObject
]

{ #category : #accessing }
WDLightState >> shadowMapCascadeDistanceWorldTransform [

	^ shadowMapCascadeDistanceWorldTransform
]

{ #category : #accessing }
WDLightState >> shadowMapCascadeDistanceWorldTransform: anObject [

	shadowMapCascadeDistanceWorldTransform := anObject
]

{ #category : #accessing }
WDLightState >> shadowMapCascadeOffsets [

	^ shadowMapCascadeOffsets
]

{ #category : #accessing }
WDLightState >> shadowMapCascadeOffsets: anObject [

	shadowMapCascadeOffsets := anObject
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapInverseTransformationMatrices [
	^ shadowMappingCameraStates collect: [:each | each inverseTransformationMatrix]
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapProjectionMatrices [
	^ shadowMapProjectionMatrices ifNil: [shadowMapProjectionMatrices:= shadowMappingCameraStates collect: [ :each | each projectionMatrix  ]
	]
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapProjectionMatrices: anArray [
	shadowMapProjectionMatrices := anArray
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapTransformationMatrices [
	^ shadowMappingCameraStates collect: [:each | each transformationMatrix]
]

{ #category : #accessing }
WDLightState >> shadowMapViewportOffsets [

	^ shadowMapViewportOffsets
]

{ #category : #accessing }
WDLightState >> shadowMapViewportOffsets: anObject [

	shadowMapViewportOffsets := anObject
]

{ #category : #accessing }
WDLightState >> shadowMapViewportScale [

	^ shadowMapViewportScale
]

{ #category : #accessing }
WDLightState >> shadowMapViewportScale: anObject [

	shadowMapViewportScale := anObject
]

{ #category : #accessing }
WDLightState >> shadowMappingCameraState [
	^ shadowMappingCameraStates
		ifEmpty: [ nil ]
		ifNotEmpty: [ shadowMappingCameraStates first ]
]

{ #category : #accessing }
WDLightState >> shadowMappingCameraState: aCameraState [

	shadowMappingCameraStates := {aCameraState}
]

{ #category : #accessing }
WDLightState >> shadowMappingCameraStates [
	^ shadowMappingCameraStates
]

{ #category : #accessing }
WDLightState >> shadowMappingCameraStates: anArray [
	shadowMappingCameraStates := anArray
]

{ #category : #accessing }
WDLightState >> spotDirection [

	^ spotDirection
]

{ #category : #accessing }
WDLightState >> spotDirection: anObject [

	spotDirection := anObject
]

{ #category : #'as yet unclassified' }
WDLightState >> transformedWithMatrix: aMatrix [
	^ self shallowCopy
		positionOrDirection: (aMatrix * positionOrDirection);
		spotDirection: (aMatrix transformVector3: spotDirection) normalized;
		yourself
]
