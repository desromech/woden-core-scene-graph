"
I am a stream for reading lines of text.
"
Class {
	#name : #WDSRWLineReader,
	#superclass : #DecoratorStream,
	#category : #'WodenSceneGraph-ReadWriter-OBJ'
}

{ #category : #converting }
WDSRWLineReader >> asSpaceTokenReader [
	^ WDSRWSpaceTokenReader on: decoratedStream
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
