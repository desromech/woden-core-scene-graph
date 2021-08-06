"
I am the normal scene layer where most of the elements are going to be located.

My camera is simply the active rendering camera.

"
Class {
	#name : #WDNormalSceneLayer,
	#superclass : #WDSceneLayer,
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #converting }
WDNormalSceneLayer >> adjustBaseCameraState: aBaseCameraState [
	^ aBaseCameraState
]

{ #category : #testing }
WDNormalSceneLayer >> isNormalSceneLayer [
	^ true
]
