"
I am a context which is used for loading asynchronous content data.
"
Class {
	#name : #WDAbstractAsyncContentContext,
	#superclass : #Object,
	#instVars : [
		'asyncProcessor',
		'contentCache'
	],
	#category : #'WodenSceneGraph-Core-Async'
}

{ #category : #accessing }
WDAbstractAsyncContentContext >> asyncProcessor [
	^ asyncProcessor
]

{ #category : #accessing }
WDAbstractAsyncContentContext >> asyncProcessor: anObject [

	^ asyncProcessor := anObject
]

{ #category : #'as yet unclassified' }
WDAbstractAsyncContentContext >> canonicalizeUri: uri [
	self subclassResponsibility
]

{ #category : #accessing }
WDAbstractAsyncContentContext >> contentCache [
	^ contentCache
]

{ #category : #accessing }
WDAbstractAsyncContentContext >> contentCache: anObject [

	contentCache := anObject
]

{ #category : #'async loading' }
WDAbstractAsyncContentContext >> enqueueLoadingModelAssetURI: modelAssetURI thenDo: aBlock [
	^ self validAsyncProcessor enqueueLoadingModelAssetURI: modelAssetURI context: self thenDo: aBlock
	
]

{ #category : #'as yet unclassified' }
WDAbstractAsyncContentContext >> fetchUriToFileReference: canonicalUri [
	self subclassResponsibility
]

{ #category : #accessing }
WDAbstractAsyncContentContext >> validAsyncProcessor [
	^ asyncProcessor ifNil: [ asyncProcessor := WDAsyncProcessor default ]
]

{ #category : #accessing }
WDAbstractAsyncContentContext >> validContentCache [
	^ contentCache ifNil: [ contentCache := WDContentCache default ]
]
