Class {
	#name : #WDSRWGGLTF2TextImporter,
	#superclass : #WDSRWGGLTF2Importer,
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #documentation }
WDSRWGGLTF2TextImporter class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : #loading }
WDSRWGGLTF2TextImporter >> readFromFileReference: fileReference [
	| gltfJson |
	fileReference readStreamDo: [ :in |
		gltfJson := (NeoJSONReader on: in) next.
	].

	^ self
		loadingDirectory: fileReference asAbsolute parent;
		processGLTFJson: gltfJson
]
