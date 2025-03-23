"
I am a floating point property.
"
Class {
	#name : 'WDSRWStanfordPLYPropertyFloatingPoint',
	#superclass : 'WDSRWStanfordPLYProperty',
	#category : 'WodenSceneGraph-ReadWriter-PLY',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'PLY'
}

{ #category : 'instance creation' }
WDSRWStanfordPLYPropertyFloatingPoint >> readFrom: inputStream [
	^ inputStream next asNumber asFloat
]
