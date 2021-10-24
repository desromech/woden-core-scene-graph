"
I am an integral property.
"
Class {
	#name : #WDIStanfordPLYPropertyIntegral,
	#superclass : #WDIStanfordPLYProperty,
	#category : #'WodenSceneGraph-ReadWriter-PLY'
}

{ #category : #'instance creation' }
WDIStanfordPLYPropertyIntegral >> readFrom: inputStream [
	^ inputStream next asInteger
]
