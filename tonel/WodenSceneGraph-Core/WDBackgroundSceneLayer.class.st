"
I am an scene layer that contains objects that are infinitely far-away such as skyboxes.

My camera position is always fixed at the origin, but is allowed to rotate.
"
Class {
	#name : #WDBackgroundSceneLayer,
	#superclass : #WDSceneLayer,
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #testing }
WDBackgroundSceneLayer >> isBackgroundSceneLayer [
	^ true
]
