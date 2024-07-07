Extension { #name : 'WDSceneElement' }

{ #category : '*WodenSceneGraph-Spec' }
WDSceneElement >> inspectionSceneTree [
	<inspectorPresentationOrder: 1 title: 'Scene Tree'>
	
	^ SpTreePresenter  new 
		roots: {self};
		children: [ :aNode | aNode children ];
		yourself
]

{ #category : '*WodenSceneGraph-Spec' }
WDSceneElement >> inspectionSceneView [
	<inspectorPresentationOrder: 0 title: 'Scene View'>
	
	^ WDSpInteractiveScenePresenter new 
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]
