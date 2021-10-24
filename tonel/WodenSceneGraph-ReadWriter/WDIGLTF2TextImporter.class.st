Class {
	#name : #WDIGLTF2TextImporter,
	#superclass : #WDIGLTF2Importer,
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDIGLTF2TextImporter class >> extension [
	^ 'gltf'
]

{ #category : #loading }
WDIGLTF2TextImporter >> loadFromFileReference: fileReference [
	| gltfJson |
	fileReference readStreamDo: [ :in |
		gltfJson := (NeoJSONReader on: in) next.
	].

	
	^ self
		loadingDirectory: fileReference asAbsolute parent;
		processGLTFJson: gltfJson
]
