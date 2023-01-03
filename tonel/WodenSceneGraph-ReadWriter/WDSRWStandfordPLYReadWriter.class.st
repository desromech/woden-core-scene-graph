"
I am a read-writer for the models in the standford .ply format.
"
Class {
	#name : #WDSRWStandfordPLYReadWriter,
	#superclass : #WDModelAssetReadWriter,
	#category : #'WodenSceneGraph-ReadWriter-PLY'
}

{ #category : #documentation }
WDSRWStandfordPLYReadWriter class >> extensions [
	^ #(ply)
]

{ #category : #documentation }
WDSRWStandfordPLYReadWriter class >> readFromFileReference: aFileReference [
	^ WDSRWStanfordPLYImporter readFromFileReference: aFileReference
]
