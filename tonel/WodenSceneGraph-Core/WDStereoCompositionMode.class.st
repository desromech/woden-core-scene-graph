"
I represent a specific mode for composing a stereo scene.
"
Class {
	#name : 'WDStereoCompositionMode',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDStereoCompositionMode class >> asStereoComposeMode [
	^ self uniqueInstance
]

{ #category : 'converting' }
WDStereoCompositionMode >> asStereoComposeMode [
	^ self
]
