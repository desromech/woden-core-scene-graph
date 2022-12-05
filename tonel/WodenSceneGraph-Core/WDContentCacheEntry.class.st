"
I am an entry in the content cache.
"
Class {
	#name : #WDContentCacheEntry,
	#superclass : #Object,
	#instVars : [
		'type',
		'name',
		'value'
	],
	#classVars : [
		'Default'
	],
	#category : #'WodenSceneGraph-Core-ContentCache'
}

{ #category : #accessing }
WDContentCacheEntry >> name [

	^ name
]

{ #category : #accessing }
WDContentCacheEntry >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDContentCacheEntry >> type [

	^ type
]

{ #category : #accessing }
WDContentCacheEntry >> type: anObject [

	type := anObject
]

{ #category : #accessing }
WDContentCacheEntry >> value [
	^ value
]

{ #category : #accessing }
WDContentCacheEntry >> value: anObject [

	value := anObject
]
