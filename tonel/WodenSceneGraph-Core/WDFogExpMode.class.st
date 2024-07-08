"
I represent an exponential fog mode.
"
Class {
	#name : 'WDFogExpMode',
	#superclass : 'WDFogMode',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDFogExpMode >> asModeIndex [
	^ 2
]

{ #category : 'testing' }
WDFogExpMode >> usesDensity [
	^ true
]
