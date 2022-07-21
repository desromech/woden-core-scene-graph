Class {
	#name : #WDSRWGLTF2TextImporter,
	#superclass : #WDSRWGLTF2Importer,
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #documentation }
WDSRWGLTF2TextImporter class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : #loading }
WDSRWGLTF2TextImporter >> readFromFileReference: fileReference [
	| gltfJson |
	fileReference readStreamDo: [ :in |
		gltfJson := (STONJSON on: in) next.
	].

	^ self
		loadingDirectory: fileReference asAbsolute parent;
		processGLTFJson: gltfJson
]
