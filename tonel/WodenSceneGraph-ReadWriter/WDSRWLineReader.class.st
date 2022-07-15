"
I am a stream for reading lines of text.
"
Class {
	#name : #WDSRWLineReader,
	#superclass : #Object,
	#instVars : [
		'decoratedStream'
	],
	#category : #'WodenSceneGraph-ReadWriter-OBJ'
}

{ #category : #'instance creation' }
WDSRWLineReader class >> on: decoratedStream [
	^ self new decoratedStream: decoratedStream; yourself
]

{ #category : #converting }
WDSRWLineReader >> asSpaceTokenReader [
	^ WDSRWSpaceTokenReader on: decoratedStream
]

{ #category : #accessing }
WDSRWLineReader >> atEnd [
	^ decoratedStream atEnd
]

{ #category : #accessing }
WDSRWLineReader >> decoratedStream [

	^ decoratedStream
]

{ #category : #accessing }
WDSRWLineReader >> decoratedStream: anObject [

	decoratedStream := anObject
]

{ #category : #accessing }
WDSRWLineReader >> next [
	^ ByteString streamContents: [ :out |
		[ decoratedStream atEnd not and: [ decoratedStream peek ~= Character cr and: [decoratedStream peek ~= Character lf]]] whileTrue: [ 
			out nextPut: decoratedStream next
		].
	
		decoratedStream peek = Character cr ifTrue: [ decoratedStream next ].
		decoratedStream peek = Character lf ifTrue: [ decoratedStream next ].
	]
]

{ #category : #accessing }
WDSRWLineReader >> nextLine [
	^ self next
]
