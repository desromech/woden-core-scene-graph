"
I am specific task which is used for performing asynchronous content loading.
"
Class {
	#name : 'WDAsyncTask',
	#superclass : 'Object',
	#instVars : [
		'action',
		'futureResult'
	],
	#category : 'WodenSceneGraph-Core-Async',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Async'
}

{ #category : 'accessing' }
WDAsyncTask >> action [

	^ action
]

{ #category : 'accessing' }
WDAsyncTask >> action: anObject [

	action := anObject
]

{ #category : 'accessing' }
WDAsyncTask >> futureResult [

	^ futureResult
]

{ #category : 'accessing' }
WDAsyncTask >> futureResult: anObject [

	futureResult := anObject
]

{ #category : 'running' }
WDAsyncTask >> run [
	futureResult value: action value
]

{ #category : 'running' }
WDAsyncTask >> runSafely [
	[ self run ] on: Error do: [ :error |
		error freeze.
		[ error debug ] fork
	]
]
