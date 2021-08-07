"
I hold a collection of different scene examples.
"
Class {
	#name : #WDSceneExamples,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Examples'
}

{ #category : #'as yet unclassified' }
WDSceneExamples class >> exampleCube [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		inspect
]

{ #category : #'see class side' }
WDSceneExamples >> seeClassSide [
]
