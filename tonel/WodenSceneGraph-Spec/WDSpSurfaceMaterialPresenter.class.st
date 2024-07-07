"
I am a Spec2 presenter for Woden surface materials.
"
Class {
	#name : 'WDSpSurfaceMaterialPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'#scenePresenter',
		'#toolbar',
		'#material => ObservableSlot',
		'#materialSceneNode',
		'#previewBaseMesh'
	],
	#category : 'WodenSceneGraph-Spec',
	#package : 'WodenSceneGraph-Spec'
}

{ #category : 'specs' }
WDSpSurfaceMaterialPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom 
		add: #toolbar expand: false;
		add: #scenePresenter;
		yourself
]

{ #category : 'initialization' }
WDSpSurfaceMaterialPresenter >> initializePresenters [
	previewBaseMesh := self previewCubeBaseMesh.
	toolbar := self newToolbar
		addItem: (SpToolbarButtonPresenter new
			label: 'Cube';
			action: [
				previewBaseMesh := self previewCubeBaseMesh.
				self updatePresenter
			];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Sphere';
			action: [
				previewBaseMesh := self previewSphereBaseMesh.
				self updatePresenter
			];
			yourself);
		yourself.

	scenePresenter := self instantiate: WDSpInteractiveScenePresenter.
	scenePresenter 	camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3)).
		
	materialSceneNode := WDSceneNode new.
	scenePresenter scene: (WDScene new
		add: materialSceneNode;
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		yourself)
]

{ #category : 'accessing' }
WDSpSurfaceMaterialPresenter >> material [

	^ material
]

{ #category : 'accessing' }
WDSpSurfaceMaterialPresenter >> material: anObject [
	material := anObject.
	self updatePresenter
]

{ #category : 'initialization' }
WDSpSurfaceMaterialPresenter >> previewCubeBaseMesh [
	^ WDMeshBuilder new
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		generateTexcoords0WithFacePlanarTransformWithScale: (Vector2 withAll: 4);
		generateTangentSpaceFrame;
		mesh
]

{ #category : 'initialization' }
WDSpSurfaceMaterialPresenter >> previewSphereBaseMesh [
	^ WDMeshBuilder new
		addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
		generateTexcoords0WithSphericalProjectionWithScale: (Vector2 withAll: 4);
		generateTangentSpaceFrame;
		mesh
]

{ #category : 'accessing' }
WDSpSurfaceMaterialPresenter >> scenePresenter [

	^ scenePresenter
]

{ #category : 'accessing' }
WDSpSurfaceMaterialPresenter >> toolbar [

	^ toolbar
]

{ #category : 'initialization' }
WDSpSurfaceMaterialPresenter >> updatePresenter [
	| mesh |
	material ifNil: [
		materialSceneNode renderables: #().
		^ self
	].

	mesh := previewBaseMesh copyWithMaterial: material.
	materialSceneNode renderables: { mesh }.
	scenePresenter refresh.
]
