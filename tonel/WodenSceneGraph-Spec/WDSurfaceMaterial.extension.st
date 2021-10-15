Extension { #name : #WDSurfaceMaterial }

{ #category : #'*WodenSceneGraph-Spec' }
WDSurfaceMaterial >> inspectionMaterialPreview [
	<inspectorPresentationOrder: 0 title: 'Material Preview'>
	
	^ WDSpInteractiveScenePresenter new 
		scene: self makeMaterialInteractivePreviewScene;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]

{ #category : #'*WodenSceneGraph-Spec' }
WDSurfaceMaterial >> makeMaterialInteractivePreviewScene [
	^ WDScene new
		add: (WDMeshBuilder new
			currentMaterial: self;
			addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
			generateTexcoords0WithSphericalProjection;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		yourself
]
