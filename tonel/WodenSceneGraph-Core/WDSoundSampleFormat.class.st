"
I represent a specific sound sample format.
"
Class {
	#name : #WDSoundSampleFormat,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Sound'
}

{ #category : #converting }
WDSoundSampleFormat class >> asSoundSampleFormat [
	^ self uniqueInstance
]

{ #category : #converting }
WDSoundSampleFormat >> asSoundSampleFormat [
	^ self
]

{ #category : #accessing }
WDSoundSampleFormat >> sampleSize [
	^ self subclassResponsibility
]
