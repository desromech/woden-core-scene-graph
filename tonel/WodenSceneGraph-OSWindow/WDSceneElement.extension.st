Extension { #name : #WDSceneElement }

{ #category : #'*WodenSceneGraph-OSWindow' }
WDSceneElement >> openInOSWindow [
	^ WDInteractiveSceneOSWindow new
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		open
]
