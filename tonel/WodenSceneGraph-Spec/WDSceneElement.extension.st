Extension { #name : #WDSceneElement }

{ #category : #'*WodenSceneGraph-Spec' }
WDSceneElement >> inspectionSceneView [
	<inspectorPresentationOrder: 0 title: 'Scene View'>
	
	^ WDSpInteractiveScenePresenter new 
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]
