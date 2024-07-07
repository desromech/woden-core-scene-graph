"
I am an asynchronouse content context which fetches files from network through http.
"
Class {
	#name : 'WDHttpAsyncContentContext',
	#superclass : 'WDAbstractAsyncContentContext',
	#instVars : [
		'baseUri'
	],
	#classVars : [
		'Default'
	],
	#category : 'WodenSceneGraph-Core-Async',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Async'
}

{ #category : 'accessing' }
WDHttpAsyncContentContext class >> baseUri: aBaseUri [
	^ self new baseUri: aBaseUri; yourself
]

{ #category : 'accessing' }
WDHttpAsyncContentContext class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
WDHttpAsyncContentContext >> baseUri [

	^ baseUri
]

{ #category : 'accessing' }
WDHttpAsyncContentContext >> baseUri: anObject [

	baseUri := anObject
]

{ #category : 'hooks' }
WDHttpAsyncContentContext >> canonicalizeUri: uri [
	((uri beginsWith: 'http:') or: [uri beginsWith: 'https:']) ifTrue: [ ^ uri ].
	^ baseUri , uri

	
]
