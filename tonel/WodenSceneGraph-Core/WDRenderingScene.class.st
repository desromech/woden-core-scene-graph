"
I encapsulate the scene state for rendering multiple camera layers.
"
Class {
	#name : #WDRenderingScene,
	#superclass : #Object,
	#instVars : [
		'mainCameraState',
		'cameraLayers',
		'globalLightingState'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderingScene >> cameraLayers [

	^ cameraLayers
]

{ #category : #accessing }
WDRenderingScene >> cameraLayers: anObject [

	cameraLayers := anObject
]

{ #category : #accessing }
WDRenderingScene >> globalLightingState [

	^ globalLightingState
]

{ #category : #accessing }
WDRenderingScene >> globalLightingState: anObject [

	globalLightingState := anObject
]

{ #category : #accessing }
WDRenderingScene >> hasReverseDepth [
	cameraLayers ifEmpty: [ ^ true ].
	^ cameraLayers first hasReverseDepth
]

{ #category : #initialization }
WDRenderingScene >> initialize [
	super initialize.
	cameraLayers := #().
	globalLightingState := WDGlobalLightingState new.
]

{ #category : #accessing }
WDRenderingScene >> lightingStateInViewSpaceWithMaxNumberOfLights: maxNumberOfLights [
	| allLightCount usedLights usedLightCount transformedLightCount |
	allLightCount := 0.
	
	cameraLayers do: [ :eachLayer |
		allLightCount := allLightCount + eachLayer lights size
	].

	usedLightCount := allLightCount min: maxNumberOfLights.	
	usedLights := Array new: usedLightCount.
	transformedLightCount := 0.
	cameraLayers do: [ :eachLayer |
		| layerLights layerLightCount layerLightsToAdd viewMatrix |
		layerLights := eachLayer lights.
		layerLightCount := layerLights size.
		layerLightCount > 0 ifTrue: [ 
			layerLightsToAdd := transformedLightCount + layerLightCount <= usedLightCount
				ifTrue: [ layerLightCount ]
				ifFalse: [ transformedLightCount + layerLightCount - usedLightCount ].
			viewMatrix := eachLayer cameraState inverseTransformationMatrix.
			
			1 to: layerLightsToAdd do: [ :i |
				transformedLightCount := transformedLightCount + 1.
				usedLights at: transformedLightCount put: ((layerLights at: i) transformedWithMatrix: viewMatrix)
			]
		].
	].


	^ WDLightingState new
		globalLightingState: globalLightingState;
		lights: usedLights;
		yourself.
]

{ #category : #accessing }
WDRenderingScene >> mainCameraState [

	^ mainCameraState
]

{ #category : #accessing }
WDRenderingScene >> mainCameraState: anObject [

	mainCameraState := anObject
]

{ #category : #accessing }
WDRenderingScene >> sampleCount [
	cameraLayers ifEmpty: [ ^ 1 ].
	^ cameraLayers first sampleCount
]
