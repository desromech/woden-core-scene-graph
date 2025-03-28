"
I am a read-writer implementation for the gltf2 text models.
"
Class {
	#name : 'WDSRWGLTF2ReadWriter',
	#superclass : 'WDModelAssetReadWriter',
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'documentation' }
WDSRWGLTF2ReadWriter class >> extensions [
	^ #(gltf)
]

{ #category : 'documentation' }
WDSRWGLTF2ReadWriter class >> readFromFileReference: aFileReference [
	^ WDSRWGLTF2TextImporter readFromFileReference: aFileReference
]
