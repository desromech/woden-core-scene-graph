"
I am a read-writer implementation for the gltf2 binary models.
"
Class {
	#name : 'WDSRWGLTF2BinaryReadWriter',
	#superclass : 'WDModelAssetReadWriter',
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'documentation' }
WDSRWGLTF2BinaryReadWriter class >> extensions [
	^ #(glb)
]

{ #category : 'documentation' }
WDSRWGLTF2BinaryReadWriter class >> readFromFileReference: aFileReference [
	^ WDSRWGLTF2BinaryImporter readFromFileReference: aFileReference
]
