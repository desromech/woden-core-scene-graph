Class {
	#name : #WDAGPUForwardLightState,
	#superclass : #Object,
	#instVars : [
		'positionOrDirection',
		'intensity',
		'spotDirection',
		'innerSpotCosCutoff',
		'outerSpotCosCutoff',
		'influenceRadius'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Uniform'
}

{ #category : #accessing }
WDAGPUForwardLightState >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDAGPUForwardLightState >> influenceRadius: anObject [

	influenceRadius := anObject
]

{ #category : #accessing }
WDAGPUForwardLightState >> innerSpotCosCutoff [

	^ innerSpotCosCutoff
]

{ #category : #accessing }
WDAGPUForwardLightState >> innerSpotCosCutoff: anObject [

	innerSpotCosCutoff := anObject
]

{ #category : #accessing }
WDAGPUForwardLightState >> intensity [

	^ intensity
]

{ #category : #accessing }
WDAGPUForwardLightState >> intensity: anObject [

	intensity := anObject
]

{ #category : #accessing }
WDAGPUForwardLightState >> outerSpotCosCutoff [

	^ outerSpotCosCutoff
]

{ #category : #accessing }
WDAGPUForwardLightState >> outerSpotCosCutoff: anObject [

	outerSpotCosCutoff := anObject
]

{ #category : #accessing }
WDAGPUForwardLightState >> positionOrDirection [

	^ positionOrDirection
]

{ #category : #accessing }
WDAGPUForwardLightState >> positionOrDirection: anObject [

	positionOrDirection := anObject
]

{ #category : #accessing }
WDAGPUForwardLightState >> spotDirection [

	^ spotDirection
]

{ #category : #accessing }
WDAGPUForwardLightState >> spotDirection: anObject [

	spotDirection := anObject
]
