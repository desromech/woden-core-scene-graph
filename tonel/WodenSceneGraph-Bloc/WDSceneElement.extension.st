Extension { #name : #WDSceneElement }

{ #category : #'*WodenSceneGraph-Bloc' }
WDSceneElement >> openInBlocSpace [
	^ WDBlInteractiveSceneElement new
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		openInSpace
]
