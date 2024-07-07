"
I am a future value that is provided by the asynchronous manager.
"
Class {
	#name : 'WDAsyncFuture',
	#superclass : 'Object',
	#instVars : [
		'value',
		'isReady'
	],
	#category : 'WodenSceneGraph-Core-Async',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Async'
}

{ #category : 'initialization' }
WDAsyncFuture >> initialize [
	super initialize.
	isReady := false.
]

{ #category : 'accessing' }
WDAsyncFuture >> isReady [

	^ isReady
]

{ #category : 'accessing' }
WDAsyncFuture >> value: anObject [
	value := anObject.
	isReady := true
]

{ #category : 'accessing' }
WDAsyncFuture >> valueOrNil [
	^ value
]
