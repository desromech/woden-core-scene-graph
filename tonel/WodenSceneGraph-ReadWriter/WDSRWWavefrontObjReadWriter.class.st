"
I am a read-writer for the models in the wavefront .obj format.
"
Class {
	#name : #WDSRWWavefrontObjReadWriter,
	#superclass : #WDModelAssetReadWriter,
	#category : #'WodenSceneGraph-ReadWriter-OBJ'
}

{ #category : #documentation }
WDSRWWavefrontObjReadWriter class >> extensions [
	^ #(obj)
]

{ #category : #documentation }
WDSRWWavefrontObjReadWriter class >> readFromFileReference: aFileReference [
	^ WDSRWWavefrontObjImporter readFromFileReference: aFileReference
]
