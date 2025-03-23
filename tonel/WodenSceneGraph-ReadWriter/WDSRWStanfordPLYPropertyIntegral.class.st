"
I am an integral property.
"
Class {
	#name : 'WDSRWStanfordPLYPropertyIntegral',
	#superclass : 'WDSRWStanfordPLYProperty',
	#category : 'WodenSceneGraph-ReadWriter-PLY',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'PLY'
}

{ #category : 'instance creation' }
WDSRWStanfordPLYPropertyIntegral >> readFrom: inputStream [
	^ inputStream next asInteger
]
