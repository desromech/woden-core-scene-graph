"
I am specific task which is used for performing asynchronous content loading.
"
Class {
	#name : #WDAsyncTask,
	#superclass : #Object,
	#instVars : [
		'future',
		'action'
	],
	#category : #'WodenSceneGraph-Core-Async'
}

{ #category : #accessing }
WDAsyncTask >> action [

	^ action
]

{ #category : #accessing }
WDAsyncTask >> action: anObject [

	action := anObject
]

{ #category : #accessing }
WDAsyncTask >> future [

	^ future
]

{ #category : #accessing }
WDAsyncTask >> future: anObject [

	future := anObject
]

{ #category : #running }
WDAsyncTask >> run [
	future value: action value
]

{ #category : #running }
WDAsyncTask >> runSafely [
	[ self run ] on: Error do: [ :error |
		error freeze.
		[ error debug ] fork
	]
]
