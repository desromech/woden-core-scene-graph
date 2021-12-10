"
I hold a collection of different scene examples.
"
Class {
	#name : #WDSceneExamples,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Examples'
}

{ #category : #'sample textures' }
WDSceneExamples class >> checkboardNormalTexture [
	^ WDSceneExamplesProceduralAssets uniqueInstance checkboardNormalTexture
]

{ #category : #'sample textures' }
WDSceneExamples class >> checkboardTexture [
	^ WDSceneExamplesProceduralAssets uniqueInstance checkboardTexture
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
WDSceneExamples class >> exampleCubeSphere [
	"
	self exampleCubeSphere
	"
	WDScene new
		add: (WDMeshBuilder new
			addCubeSphereWithRadius: 0.5 subdivisions: 2;
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
WDSceneExamples class >> exampleEmpty [
	"
	self exampleEmpty
	"
	WDScene new inspect
]

{ #category : #'sample scenes' }
WDSceneExamples class >> examplePool [
	| tilesMaterial concreteMaterial waterMaterial borderThickness |
	tilesMaterial := WDSceneExamplesProceduralAssets uniqueInstance tileMaterial.
	concreteMaterial := WDMetallicRoughnessMaterial new.
	waterMaterial := WDSceneExamplesProceduralAssets uniqueInstance poolWaterMaterial.

	borderThickness := 0.5.
	WDScene new
		add:(WDMeshBuilder new
			currentMaterial: tilesMaterial;

			translateToX: (borderThickness*0.5) negated - 4.5 y: -1.0 z: 0.0;
			addCubeWithWidth: 4.0 - borderThickness height: 2.0 depth: 5.0 + (borderThickness*2.0);
		
			translateToX: (borderThickness*0.5)+ 4.5 y: -1.0 z: 0.0;
			addCubeWithWidth: 4.0 - borderThickness height: 2.0 depth: 5.0 + (borderThickness*2.0);
		
			translateToX: 0.0 y: -1.0 z: borderThickness + 4.5;
			addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;
		
			translateToX: 0.0 y: -1.0 z: borderThickness negated - 4.5;
			addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;

			"Bottom"
			currentMaterial: concreteMaterial;
			translateToX: 0.0 y: -2.05 z: 0.0;
			addCubeWithWidth: 5.0 height: 0.1 depth: 5.0;

			"Border"
			translateToX: -2.5 - (borderThickness*0.5) y: -1.0 z: 0.0;
			addCubeWithWidth: borderThickness height: 2.2 depth: 5.0 + (borderThickness*2.0);
		
			translateToX: 2.5 + (borderThickness*0.5) y: -1.0 z: 0.0;
			addCubeWithWidth: borderThickness height: 2.2 depth: 5.0 + (borderThickness*2.0);
		
			translateToX: 0.0 y: -1.0 z: 2.5 + (borderThickness*0.5);
			addCubeWithWidth: 5.0 height: 2.2 depth: borderThickness;
		
			translateToX: 0.0 y: -1.0 z: -2.5 - (borderThickness*0.5);
			addCubeWithWidth: 5.0 height: 2.2 depth: borderThickness;
			
			generateTexcoords0WithFacePlanarTransformWithScale: 4 asVector2;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDMeshBuilder new
			currentMaterial: waterMaterial;
			addPlaneWithWidth: 5 height: 5;
			generateTexcoords0WithFacePlanarTransformWithScale: 1 asVector2;
			generateTangentSpaceFrame;
			mesh
		) asSceneNode
			translateToX: 0.0 y: -0.3 z: 0.0;
			yourself);
		add: ((WDDirectionalLightSource new
			intensity: (Vector3 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
			asSceneNode)
				rotateDegreesOnX: -35;
				translateToX: 0.0 y: 1.5 z: 2.5;
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
WDSceneExamples class >> exampleTexturedCube4 [
	"
	self exampleTexturedCube4
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: WDSceneExamplesProceduralAssets uniqueInstance tileMaterial;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			generateTexcoords0WithFacePlanarTransformWithScale: 2 asVector2;
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
WDSceneExamples class >> exampleTexturedCubeSphere [
	"
	self exampleCubeSphere
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
			addCubeSphereWithRadius: 0.5 subdivisions: 2;
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
WDSceneExamples class >> exampleTexturedCubeSphere2 [
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
			addCubeSphereWithRadius: 0.5 subdivisions: 2;
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
WDSceneExamples class >> exampleTexturedCubeSphere3 [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDUnlitMaterial new
				colorTexture: self checkboardTexture;
				yourself);
			addCubeSphereWithRadius: 0.5 subdivisions: 2;
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
	self exampleUVSphere
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
