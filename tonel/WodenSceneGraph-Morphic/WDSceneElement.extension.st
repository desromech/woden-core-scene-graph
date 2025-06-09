Extension { #name : 'WDSceneElement' }

{ #category : '*WodenSceneGraph-Morphic' }
WDSceneElement >> openInMorphicWindow [
	^ WDInteractiveSceneMorph new
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		openInWindow
]

{ #category : '*WodenSceneGraph-Morphic' }
WDSceneElement >> openInWindow [
	(self respondsTo: #inspectionSceneView:) ifTrue: [ ^ self inspect ].
	^ self openInMorphicWindow
]
