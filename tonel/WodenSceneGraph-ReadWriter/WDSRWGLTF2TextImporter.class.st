"
I am importer for glTF 2 text models.
"
Class {
	#name : 'WDSRWGLTF2TextImporter',
	#superclass : 'WDSRWGLTF2Importer',
	#category : 'WodenSceneGraph-ReadWriter-GLTF2',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'GLTF2'
}

{ #category : 'documentation' }
WDSRWGLTF2TextImporter class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : 'loading' }
WDSRWGLTF2TextImporter >> readFromFileReference: fileReference [
	| gltfJson |
	fileReference readStreamDo: [ :in |
		gltfJson := STONJSON fromStream: in.
	].

	^ self
		loadingDirectory: fileReference asAbsolute parent;
		processGLTFJson: gltfJson
]
