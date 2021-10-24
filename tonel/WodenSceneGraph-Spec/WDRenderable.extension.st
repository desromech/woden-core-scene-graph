Extension { #name : #WDRenderable }

{ #category : #'*WodenSceneGraph-Spec' }
WDRenderable >> inspectionSceneView [
	<inspectorPresentationOrder: 0 title: 'Mesh Preview'>
	
	^ WDSpInteractiveScenePresenter new 
		scene: self asSceneElement;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]
