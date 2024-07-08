"
I represent an exponential squared fog mode.
"
Class {
	#name : 'WDFogExp2Mode',
	#superclass : 'WDFogMode',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDFogExp2Mode >> asModeIndex [
	^ 3
]

{ #category : 'testing' }
WDFogExp2Mode >> usesDensity [
	^ true
]
