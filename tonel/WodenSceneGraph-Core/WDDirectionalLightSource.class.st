"
I am a directional light source.

I point towards the front direction, so that my orientation can be adjusted through my parent scene node transformation.
"
Class {
	#name : #WDDirectionalLightSource,
	#superclass : #WDLightSource,
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #adding }
WDDirectionalLightSource >> addToRenderingScene: renderingScene withGlobalTransform: globalTransform [
	renderingScene addLight: (self asLightStateWithTransform: globalTransform)
]

{ #category : #converting }
WDDirectionalLightSource >> asLightStateWithTransform: renderingTransform [
	^ WDLightState new
		positionOrDirection: (Vector4 xyz: renderingTransform matrix thirdColumn w: 0.0);
		intensity: intensity;
		yourself.
]
