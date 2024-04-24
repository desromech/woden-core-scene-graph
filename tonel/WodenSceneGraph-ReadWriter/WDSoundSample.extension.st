Extension { #name : #WDSoundSample }

{ #category : #'*WodenSceneGraph-ReadWriter' }
WDSoundSample class >> forFileRereference: aFileReference [
	^ WDSRWWaveFileReader readFromFileReference: aFileReference
]
