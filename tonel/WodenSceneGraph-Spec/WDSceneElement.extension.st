Extension { #name : 'WDSceneElement' }

{ #category : '*WodenSceneGraph-Spec' }
WDSceneElement >> inspectionSceneTree: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Scene Tree'>
	
	^ (aBuilder instantiate: SpTreePresenter)
		roots: {self};
		children: [ :aNode | aNode children ];
		yourself
]

{ #category : '*WodenSceneGraph-Spec' }
WDSceneElement >> inspectionSceneView: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Scene View'>
	
	^ (aBuilder instantiate: WDSpInteractiveScenePresenter)
		scene: self;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]
