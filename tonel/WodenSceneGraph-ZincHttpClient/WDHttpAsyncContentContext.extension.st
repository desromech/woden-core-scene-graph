Extension { #name : #WDHttpAsyncContentContext }

{ #category : #'*WodenSceneGraph-ZincHttpClient' }
WDHttpAsyncContentContext >> fetchUriToFileReference: canonicalUri [
	| znUrl fileReference contents |
	znUrl := ZnUrl fromString: canonicalUri.
	fileReference := FileSystem memory / znUrl lastPathSegment.
	contents := znUrl retrieveContents.
	fileReference binaryWriteStreamDo: [ :out | out nextPutAll: contents ].
	^ fileReference
]
