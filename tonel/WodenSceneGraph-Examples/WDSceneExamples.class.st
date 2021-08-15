"
I hold a collection of different scene examples.
"
Class {
	#name : #WDSceneExamples,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Examples'
}

{ #category : #'sample textures' }
WDSceneExamples class >> checkboardMaterial [
	^ WDMetallicRoughnessMaterial new
		roughnessFactor: 0.3;
		metallicFactor: 0.0;
		baseColorTexture: self checkboardTexture;
		yourself.
]

{ #category : #'sample textures' }
WDSceneExamples class >> checkboardNormalTexture [
	^ WDTexture forNormalMapForm: AGPUSampleImmediateRendererCommon basicNew checkboardNormalMapTextureForm.
]

{ #category : #'sample textures' }
WDSceneExamples class >> checkboardTexture [
	^ WDTexture forColorForm: AGPUSampleImmediateRendererCommon basicNew checkboardTextureForm.
]

{ #category : #'basic shapes' }
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

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedCube [
	"
	self exampleTexturedCube
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedCube2 [
	"
	self exampleTexturedCube2
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedCube3 [
	"
	self exampleTexturedCube3
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDUnlitMaterial new
				colorTexture: self checkboardTexture;
				yourself);
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			mesh);
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
			addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
			generateTexcoords0WithSphericalProjection;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere2 [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
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
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere3 [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDUnlitMaterial new
				colorTexture: self checkboardTexture;
				yourself);
			addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
			generateTexcoords0WithSphericalProjection;
			mesh);
		add: ((WDPointLightSource new
			intensity: (Vector3 x: 0.8 y: 0.8 z: 0.2) * 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		inspect
]

{ #category : #'basic shapes' }
WDSceneExamples class >> exampleUVSphere [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
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
