"
I represent the no fog mode.
"
Class {
	#name : 'WDFogNoneMode',
	#superclass : 'WDFogMode',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDFogNoneMode >> asModeIndex [
	^ 0
]

{ #category : 'testing' }
WDFogNoneMode >> isNone [
	^ true
]
