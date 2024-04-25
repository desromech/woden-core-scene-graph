"
I am an async loading context which is used for loading content from files.
"
Class {
	#name : #WDFileAsyncContentContext,
	#superclass : #WDAbstractAsyncContentContext,
	#instVars : [
		'workingDirectory'
	],
	#classVars : [
		'Default'
	],
	#category : #'WodenSceneGraph-Core-Async'
}

{ #category : #accessing }
WDFileAsyncContentContext class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
WDFileAsyncContentContext class >> workingDirectory: aWorkingDirectory [
	^ self new workingDirectory: aWorkingDirectory; yourself
]

{ #category : #hooks }
WDFileAsyncContentContext >> canonicalizeUri: uri [
	| solvedDirectory |
	(uri beginsWith: 'file:') ifTrue: [ ^ uri ].
	solvedDirectory := self validWorkingDirectory resolve: uri asFileReference.
	^ 'file:' , solvedDirectory fullName
]

{ #category : #hooks }
WDFileAsyncContentContext >> fetchUriToFileReference: canonicalUri [
	^ (canonicalUri withoutPrefix: 'file:') asFileReference
]

{ #category : #hooks }
WDFileAsyncContentContext >> validWorkingDirectory [
	^ workingDirectory ifNil: [ FileSystem disk workingDirectory ]
]

{ #category : #accessing }
WDFileAsyncContentContext >> workingDirectory [

	^ workingDirectory
]

{ #category : #accessing }
WDFileAsyncContentContext >> workingDirectory: anObject [

	workingDirectory := anObject
]
