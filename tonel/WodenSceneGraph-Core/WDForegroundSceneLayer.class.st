"
I am an scene layer that contains objects that are near than everything else, such as a HUD, or something that hangs from the camera.

My camera position is always fixed and it never rotates.
"
Class {
	#name : 'WDForegroundSceneLayer',
	#superclass : 'WDSceneLayer',
	#category : 'WodenSceneGraph-Core-Scene',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Scene'
}

{ #category : 'converting' }
WDForegroundSceneLayer >> adjustBaseCameraState: aBaseCameraState [
	^ aBaseCameraState asCameraStateForForegroundLayer
]

{ #category : 'testing' }
WDForegroundSceneLayer >> isForegroundSceneLayer [
	^ true
]
