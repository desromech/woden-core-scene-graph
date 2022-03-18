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
		'influenceRadius'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

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
	intensity := 0.0.
	spotDirection := Vector3 zeros.
	innerSpotCosCutoff := -1.0.
	outerSpotCosCutoff := -1.0.
	influenceRadius := 1.0.
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
