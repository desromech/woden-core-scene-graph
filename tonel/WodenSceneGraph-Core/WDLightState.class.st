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
		'shadowMappingCameraState',
		'shadowMapViewportScale',
		'shadowMapViewportOffset',
		'shadowMapProjectionMatrix'
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
	shadowMappingCameraState := nil.
	
	shadowMapViewportScale := Vector2 x: 0.5 y: 0.5.
	shadowMapViewportOffset := Vector2 x: 0.5 y: 0.5.
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

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapInverseTransformationMatrix [
	^ shadowMappingCameraState
		ifNil: [ Matrix4x4 identity ]
		ifNotNil: [ shadowMappingCameraState inverseTransformationMatrix ]
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapProjectionMatrix [
	^ shadowMapProjectionMatrix ifNil: [shadowMappingCameraState
			ifNil: [ Matrix4x4 identity ]
			ifNotNil: [ shadowMappingCameraState projectionMatrix ]
	]
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapProjectionMatrix: aMatrix [
	shadowMapProjectionMatrix := aMatrix
]

{ #category : #'as yet unclassified' }
WDLightState >> shadowMapTransformationMatrix [
	^ shadowMappingCameraState
		ifNil: [ Matrix4x4 identity ]
		ifNotNil: [ shadowMappingCameraState transformationMatrix ]
]

{ #category : #accessing }
WDLightState >> shadowMapViewportOffset [

	^ shadowMapViewportOffset
]

{ #category : #accessing }
WDLightState >> shadowMapViewportOffset: anObject [

	shadowMapViewportOffset := anObject
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

	^ shadowMappingCameraState
]

{ #category : #accessing }
WDLightState >> shadowMappingCameraState: anObject [

	shadowMappingCameraState := anObject
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
