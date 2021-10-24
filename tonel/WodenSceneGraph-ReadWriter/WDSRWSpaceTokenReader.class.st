"
I am a stream for reading space separated tokens from a stream
"
Class {
	#name : #WDSRWSpaceTokenReader,
	#superclass : #DecoratorStream,
	#category : #'WodenSceneGraph-ReadWriter-OBJ'
}

{ #category : #converting }
WDSRWSpaceTokenReader >> asLineReader [
	^ WDSRWLineReader on: decoratedStream
]

{ #category : #private }
WDSRWSpaceTokenReader >> next [
	self skipWhite.
	^ ByteString streamContents: [ :out |
		[decoratedStream atEnd not and: [ decoratedStream peek > Character space ]] whileTrue: [
			out nextPut: decoratedStream next
		]
	]
]

{ #category : #private }
WDSRWSpaceTokenReader >> nextToken [
	^ self next
]

{ #category : #private }
WDSRWSpaceTokenReader >> skipWhite [
	[decoratedStream atEnd not and: [ decoratedStream peek <= Character space ]] whileTrue: [
		decoratedStream next
	]
]
