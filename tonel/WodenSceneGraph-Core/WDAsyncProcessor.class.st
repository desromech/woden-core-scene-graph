"
I am a processor which is used for asynchronous tasks.
"
Class {
	#name : 'WDAsyncProcessor',
	#superclass : 'Object',
	#instVars : [
		'taskQueue',
		'pendingTaskSemaphore',
		'asyncProcessorProcess'
	],
	#classVars : [
		'Default'
	],
	#category : 'WodenSceneGraph-Core-Async',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Async'
}

{ #category : 'accessing' }
WDAsyncProcessor class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'initialization' }
WDAsyncProcessor class >> reset [
	<script>
	Default := nil
]

{ #category : 'accessing' }
WDAsyncProcessor >> asyncProcessorProcess [
	[ self asyncProcessorProcessIteration ] repeat
]

{ #category : 'private' }
WDAsyncProcessor >> asyncProcessorProcessIteration [
	| nextTask |
	pendingTaskSemaphore consumeAllSignals.
	[ nextTask := taskQueue nextOrNil ] whileNotNil: [ 
		nextTask runSafely
	].
	
	pendingTaskSemaphore wait
]

{ #category : 'tasks' }
WDAsyncProcessor >> enqueueLoadingAssetURI: assetURI type: assetType context: context loadWith: loadingBlock thenDo: thenBlock [
	^ self enqueueTask: [
		| canonicalUri loadResult |
		canonicalUri := context canonicalizeUri: assetURI.
		loadResult := (context validContentCache getEntryForAssetNamed: canonicalUri type: assetType) ifNil: [
			| fetchedUri loadedAsset |
			fetchedUri := context fetchUriToFileReference: canonicalUri.
			loadedAsset := (fetchedUri isNil or: [ fetchedUri exists not ]) ifTrue: [ 
				nil
			] ifFalse: [
				loadingBlock value: fetchedUri
			].
			
			context validContentCache setForAssetNamed: canonicalUri type: assetType entry: loadedAsset.
			loadedAsset
		] ifNotNil: [ :cachedEntry |
			cachedEntry value
		].
	
		thenBlock value: loadResult
	]
]

{ #category : 'tasks' }
WDAsyncProcessor >> enqueueLoadingModelAssetURI: modelAssetURI context: context thenDo: aBlock [
	^ self enqueueLoadingAssetURI: modelAssetURI type: #model context: context loadWith: [ :solvedFileReference |
		WDModelAssetReadWriter readFileNamed: solvedFileReference
	] thenDo: aBlock
]

{ #category : 'tasks' }
WDAsyncProcessor >> enqueueTask: aBlock [
	| futureResult task |
	futureResult := WDAsyncFuture new.
	task := WDAsyncTask new
		futureResult: futureResult;
		action: aBlock;
		yourself.
	taskQueue nextPut: task.
	pendingTaskSemaphore signal.
	^ futureResult
	
]

{ #category : 'initialization' }
WDAsyncProcessor >> initialize [
	super initialize.
	taskQueue := SharedQueue new.
	pendingTaskSemaphore := Semaphore new.
	asyncProcessorProcess := self starkAsyncProcessorProcess.
]

{ #category : 'private' }
WDAsyncProcessor >> starkAsyncProcessorProcess [
	asyncProcessorProcess := [ self asyncProcessorProcess ] forkAt: Processor userBackgroundPriority
]
