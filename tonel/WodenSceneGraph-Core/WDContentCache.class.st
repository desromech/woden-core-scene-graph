"
I am a content cache which is used for avoiding duplicated asynchronous content loading.
"
Class {
	#name : 'WDContentCache',
	#superclass : 'Object',
	#instVars : [
		'assetCache'
	],
	#classVars : [
		'Default'
	],
	#category : 'WodenSceneGraph-Core-ContentCache',
	#package : 'WodenSceneGraph-Core',
	#tag : 'ContentCache'
}

{ #category : 'accessing' }
WDContentCache class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'initialization' }
WDContentCache class >> reset [
	<script>
	Default := nil
]

{ #category : 'cache entries' }
WDContentCache >> getEntryForAssetNamed: assetName type: assetType [
	^ assetCache at: {assetType . assetName} ifAbsent: [ nil ]
]

{ #category : 'initialization' }
WDContentCache >> initialize [
	super initialize.
	assetCache := Dictionary new.
]

{ #category : 'cache entries' }
WDContentCache >> setForAssetNamed: assetName type: assetType entry: entry [
	^ assetCache at: {assetType . assetName} put: (WDContentCacheEntry new
		type: assetType;
		name: assetName;
		value: entry;
		yourself)
]
