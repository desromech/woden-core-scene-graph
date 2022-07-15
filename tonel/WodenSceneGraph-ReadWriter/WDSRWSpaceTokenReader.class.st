"
I am a stream for reading space separated tokens from a stream
"
Class {
	#name : #WDSRWSpaceTokenReader,
	#superclass : #Object,
	#instVars : [
		'decoratedStream'
	],
	#category : #'WodenSceneGraph-ReadWriter-OBJ'
}

{ #category : #'instance creation' }
WDSRWSpaceTokenReader class >> on: decoratedStream [
	^ self new decoratedStream: decoratedStream; yourself
]

{ #category : #converting }
WDSRWSpaceTokenReader >> asLineReader [
	^ WDSRWLineReader on: decoratedStream
]

{ #category : #accessing }
WDSRWSpaceTokenReader >> atEnd [
	^ decoratedStream atEnd
]

{ #category : #accessing }
WDSRWSpaceTokenReader >> decoratedStream [

	^ decoratedStream
]

{ #category : #accessing }
WDSRWSpaceTokenReader >> decoratedStream: anObject [

	decoratedStream := anObject
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
