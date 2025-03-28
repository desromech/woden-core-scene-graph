"
I hold a collection of different scene examples.
"
Class {
	#name : 'WDSceneExamples',
	#superclass : 'Object',
	#category : 'WodenSceneGraph-Examples',
	#package : 'WodenSceneGraph-Examples'
}

{ #category : 'sample textures' }
WDSceneExamples class >> checkboardNormalTexture [
	^ WDSceneExamplesProceduralAssets uniqueInstance checkboardNormalTexture
]

{ #category : 'sample textures' }
WDSceneExamples class >> checkboardTexture [
	^ WDSceneExamplesProceduralAssets uniqueInstance checkboardTexture
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleAnimatedCube [
	"
	self exampleAnimatedCube
	"
	| cube animationTime |
	cube := (WDMeshBuilder new
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh) asSceneNode.
	animationTime := 0.0.
	WDScene new
		add: cube;
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		updateBlock: [ :delta |
			animationTime := animationTime + delta.
			cube position: (Vector3 y: (animationTime * Float twoPi) sin * 1.5).
			true
		];
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleAnimatedShadowCastingDirectionalLight [
	"
	self exampleAnimatedShadowCastingDirectionalLight
	"
	| scene lightSource currentTime |
	scene := WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		yourself.
	lightSource := (WDDirectionalLightSource new
		castShadows: true;
		color: (Vector3 x: 0.8 y: 0.8 z: 0.7);
		asSceneNode)
			rotateDegreesOnX: 0;
			rotateDegreesOnY: -135;
			position: (Vector3 x: -1.0 y: 2.0 z: -2.0);
			yourself.

	currentTime := 0.0.
	scene
		add: lightSource;
		updateBlock: [ :delta |
			| theta |
			currentTime := currentTime + delta.
			
			theta := currentTime.
			lightSource transform: (TRSTransform3D identity
				rotateRadiansOnX: currentTime negated;
				rotateDegreesOnY: -135;
				yourself)
		];
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleAnimatedShadowCastingPointLight [
	"
	self exampleAnimatedShadowCastingPointLight
	"
	| scene lightSource currentTime |
	scene := WDScene new
		add: (WDMeshBuilder new

			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 0.3 y: 0.3 z: 0.3 w: 1.0);
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			"Floor"
			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			"Ceiling"
			translateToX: 0 y: 3.0 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			"Front Wall"
			translateToX: 0 y: 1.5 z: -5.0;
			addCubeWithWidth: 10.0 height: 3.0 depth: 0.25;

			"Back Wall"
			translateToX: 0 y: 1.5 z: 5.0;
			addCubeWithWidth: 10.0 height: 3.0 depth: 0.25;

			"Left Wall"
			translateToX: -5.0 y: 1.5 z: 0.0;
			addCubeWithWidth: 0.25 height: 3.0 depth: 10.0;

			"Right Wall"
			translateToX: 5.0 y: 1.5 z: 0.0;
			addCubeWithWidth: 0.25 height: 3.0 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			"Cube row"
			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			"Top row"
			translateToX: 2.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		yourself.
	
	lightSource := (WDPointLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.8 z: 0.7);
			intensity: 10.0;
			influenceRadius: 10.0;
			asSceneNode)
				position: (Vector3 x: 0.0 y: 1.5 z: 0.0);
				yourself.
			
	currentTime := 0.0.
	scene
		add: lightSource;
		updateBlock: [ :delta |
			| theta |
			currentTime := currentTime + delta.
			
			theta := currentTime.
			lightSource position: (Vector3 x: 0.0 y: 1.5 z: 0.0) + ((Vector3 x: theta cos y: 0.0 z: theta sin) * 1.5)		];
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleAnimatedShadowCastingSpotLight2 [
	"
	self exampleShadowCastingSpotLight2
	"
	| scene firstLight secondLight thirdLight currentTime |
	scene := WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: WDSceneExamples checkboardTexture;
				normalTexture: WDSceneExamples checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: WDSceneExamples checkboardTexture;
				normalTexture: WDSceneExamples checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		yourself.

	firstLight := (WDSpotLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.6 z: 0.6);
			intensity: 10.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: -135;
				position: (Vector3 x: -1.0 y: 2.0 z: -2.0);
				yourself.

	secondLight := (WDSpotLightSource new
			castShadows: true;
			intensity: (Vector3 x: 0.6 y: 0.8 z: 0.6) * 10.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: 135;
				position: (Vector3 x: 1.0 y: 2.0 z: -2.0);
				yourself.
				
	thirdLight := (WDSpotLightSource new
			castShadows: true;
			intensity: (Vector3 x: 0.6 y: 0.6 z: 0.8) * 10.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				position: (Vector3 x: 0.0 y: 2.0 z: 4.0);
				yourself.

	currentTime := 0.
	scene
		add: firstLight;
		add: secondLight;
		add: thirdLight;
		updateBlock: [ :delta |
			| theta |
			currentTime := currentTime + delta.
			
			theta := currentTime.
			firstLight position: (Vector3 x: -1.0 y: 2.0 z: -2.0) + ((Vector3 x: theta cos y: 0.0 z: theta sin) * 0.5).

			theta := currentTime*1.15 + 0.5.
			secondLight position: (Vector3 x: 1.0 y: 2.0 z: -2.0) + ((Vector3 x: theta cos y: 0.0 z: theta sin) * 0.5).

			theta := currentTime*1.3 + 1.3.
			thirdLight position: (Vector3 x: 0.0 y: 2.0 z: 4.0) + ((Vector3 x: theta cos y: 0.0 z: theta sin) * 0.5)

		];
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleCube [
	"
	self exampleCube
	"
	WDScene new
		add: (WDMeshBuilder new
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			mesh);
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleCubeSphere [
	"
	self exampleCubeSphere
	"
	WDScene new
		add: (WDMeshBuilder new
			addCubeSphereWithRadius: 0.5 subdivisions: 2;
			mesh);
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleEmpty [
	"
	self exampleEmpty
	"
	WDScene new openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleManyCubes [
	"
	self exampleManyCubes
	"
	| scene cubeMesh |
	scene := WDScene new.
	cubeMesh := WDMeshBuilder new
		currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones * 0.5;
		generateTangentSpaceFrame;
		mesh.
		
	1 to: 1000 do: [ :cubeIndex |
		| position |
		position := cubeIndex signedRandomNoiseVector3 * 40.
		scene add: (cubeMesh asSceneNode
			scale: (Vector2 x: position x y: position z) randomNoiseVector3 *3 + 1.0;
			position: position;
			yourself)
	].

	scene add: (WDPointLightSource new
		color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
		intensity: 300.0;
		influenceRadius: 100.0;
		asSceneNode).
		
	scene openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleManyCubesAndLights [
	"
	self exampleManyCubesAndLights
	"
	| scene cubeMesh |
	scene := WDScene new.
	cubeMesh := WDMeshBuilder new
		currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones * 0.5;
		generateTangentSpaceFrame;
		mesh.
		
	1 to: 1000 do: [ :cubeIndex |
		| position |
		position := cubeIndex signedRandomNoiseVector3 * 40.
		scene add: (cubeMesh asSceneNode
			scale: (Vector2 x: position x y: position z) randomNoiseVector3 *3 + 1.0;
			position: position;
			yourself)
	].

	1 to: 1000 do: [ :lightIndex |
		| position |
		position := (Vector2 x: lightIndex y: 1) signedRandomNoiseVector3 * 40.
		scene add: ((WDPointLightSource new
			color: (Vector2 x: lightIndex y: 2) randomNoiseVector3;
			intensity: 30.0;
			influenceRadius: 10.0;
			asSceneNode)
				position: position;
				yourself).
	].

	scene openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleManyCubesSingleMesh [
	"
	self exampleManyCubesSingleMesh
	"
	| scene meshBuilder |
	scene := WDScene new.
	
	meshBuilder := WDMeshBuilder new
		currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself).

	1 to: 1000 do: [ :cubeIndex |
		| position |
		position := cubeIndex signedRandomNoiseVector3 * 40.
		meshBuilder
			transform: (TRSTransform3D scale: (Vector2 x: position x y: position z) randomNoiseVector3 *3 + 1.0 translation: position);
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	].

	scene add: (meshBuilder	generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones * 0.5;
		generateTangentSpaceFrame;
		mesh).

	scene add: (WDPointLightSource new
		color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
		intensity: 300.0;
		influenceRadius: 100.0;
		asSceneNode).
		
	scene openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleManyCubesSingleMeshAndLights [
	"
	self exampleManyCubesSingleMeshAndLights
	"
	| scene meshBuilder |
	scene := WDScene new.
	
	meshBuilder := WDMeshBuilder new
		currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself).

	1 to: 1000 do: [ :cubeIndex |
		| position |
		position := cubeIndex signedRandomNoiseVector3 * 40.
		meshBuilder
			transform: (TRSTransform3D scale: (Vector2 x: position x y: position z) randomNoiseVector3 *3 + 1.0 translation: position);
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	].

	scene add: (meshBuilder	generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones * 0.5;
		generateTangentSpaceFrame;
		mesh).

	1 to: 1000 do: [ :lightIndex |
		| position |
		position := (Vector2 x: lightIndex y: 1) signedRandomNoiseVector3 * 40.
		scene add: ((WDPointLightSource new
			color: (Vector2 x: lightIndex y: 2) randomNoiseVector3;
			intensity: 30.0;
			influenceRadius: 10.0;
			asSceneNode)
				position: position;
				yourself).
	].
		
	scene openInWindow
]

{ #category : 'sample scenes' }
WDSceneExamples class >> exampleOpaquePool [
	"
	self exampleOpaquePool
	"
	| tilesMaterial concreteMaterial waterMaterial borderThickness |
	tilesMaterial := WDSceneExamplesProceduralAssets uniqueInstance tileMaterial.
	concreteMaterial := WDMetallicRoughnessMaterial default.
	waterMaterial := WDSceneExamplesProceduralAssets uniqueInstance poolWaterOpaqueMaterial.

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
			color: (Vector3 x: 1.0 y: 1.0 z: 0.8) normalized;
			intensity: 0.7;
			asSceneNode)
				rotateDegreesOnX: -35;
				translateToX: 0.0 y: 1.5 z: 2.5;
				yourself);
		openInWindow
]

{ #category : 'sample scenes' }
WDSceneExamples class >> examplePool [
	"
	self examplePool
	"
	| tilesMaterial concreteMaterial waterMaterial borderThickness |
	tilesMaterial := WDSceneExamplesProceduralAssets uniqueInstance tileMaterial.
	concreteMaterial := WDMetallicRoughnessMaterial default.
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
			color: (Vector3 x: 1.0 y: 1.0 z: 0.8) normalized;
			intensity: 0.7;
			asSceneNode)
				rotateDegreesOnX: -35;
				translateToX: 0.0 y: 1.5 z: 2.5;
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleShadowCastingDirectionalLight [
	"
	self exampleShadowCastingDirectionalLight
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDDirectionalLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.8 z: 0.7);
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: -135;
				position: (Vector3 x: -1.0 y: 2.0 z: -2.0);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleShadowCastingPointLight [
	"
	self exampleShadowCastingPointLight
	"
	WDScene new
		add: (WDMeshBuilder new

			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 0.3 y: 0.3 z: 0.3 w: 1.0);
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			"Floor"
			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			"Ceiling"
			translateToX: 0 y: 3.0 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			"Front Wall"
			translateToX: 0 y: 1.5 z: -5.0;
			addCubeWithWidth: 10.0 height: 3.0 depth: 0.25;

			"Back Wall"
			translateToX: 0 y: 1.5 z: 5.0;
			addCubeWithWidth: 10.0 height: 3.0 depth: 0.25;

			"Left Wall"
			translateToX: -5.0 y: 1.5 z: 0.0;
			addCubeWithWidth: 0.25 height: 3.0 depth: 10.0;

			"Right Wall"
			translateToX: 5.0 y: 1.5 z: 0.0;
			addCubeWithWidth: 0.25 height: 3.0 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			"Cube row"
			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			"Top row"
			translateToX: 2.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 2.25 z: -1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDPointLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.8 z: 0.7);
			intensity: 10.0;
			influenceRadius: 10.0;
			asSceneNode)
				position: (Vector3 x: 0.0 y: 1.5 z: 0.0);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleShadowCastingSpotLight [
	"
	self exampleShadowCastingSpotLight
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDSpotLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.8 z: 0.7);
			intensity: 20.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: -135;
				position: (Vector3 x: -1.0 y: 2.0 z: -2.0);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleShadowCastingSpotLight2 [
	"
	self exampleShadowCastingSpotLight2
	"
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.4;
				metallicFactor: 0.0;
				yourself);

			translateToX: 0 y: -0.125 z: 0;
			addCubeWithWidth: 10.0 height: 0.25 depth: 10.0;

			translateToX: 0 y: 0.5 z: 0;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;

			translateToX: 2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 2.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: (WDMeshBuilder new
			currentMaterial: (WDMetallicRoughnessMaterial new
				baseColorFactor: (Vector4 x: 1.0 y: 1.0 z: 1.0 w: 0.8);
				baseColorTexture: self checkboardTexture;
				normalTexture: self checkboardNormalTexture;
				roughnessFactor: 0.1;
				metallicFactor: 0.0;
				withAlphaBlending;
				yourself);

			translateToX: 2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: 0.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -1.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			translateToX: -2.0 y: 0.25 z: 1.0;
			addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;

			generateTexcoords0WithFacePlanarTransformWithScale: Vector2 ones;
			generateTangentSpaceFrame;
			mesh);
		add: ((WDSpotLightSource new
			castShadows: true;
			color: (Vector3 x: 0.8 y: 0.6 z: 0.6);
			intensity: 5.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: -135;
				position: (Vector3 x: -1.0 y: 2.0 z: -2.0);
				yourself);
		add: ((WDSpotLightSource new
			castShadows: true;
			color: (Vector3 x: 0.6 y: 0.8 z: 0.6);
			intensity: 5.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				rotateDegreesOnY: 135;
				position: (Vector3 x: 1.0 y: 2.0 z: -2.0);
				yourself);
		add: ((WDSpotLightSource new
			castShadows: true;
			color: (Vector3 x: 0.6 y: 0.6 z: 0.8);
			intensity: 5.0;
			influenceRadius: 10.0;
			asSceneNode)
				rotateDegreesOnX: -45;
				position: (Vector3 x: 0.0 y: 2.0 z: 4.0);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
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
		openInWindow
]

{ #category : 'basic shapes' }
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleTexturedCubeSphere2 [
	"
	self exampleTexturedCubeSphere2
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleTexturedCubeSphere3 [
	"
	self exampleTexturedCubeSphere3
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere [
	"
	self exampleTexturedUVSphere
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere2 [
	"
	self exampleTexturedUVSphere2
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleTexturedUVSphere3 [
	"
	self exampleTexturedUVSphere3
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
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleUVSphere [
	"
	self exampleUVSphere
	"
	WDScene new
		add: (WDMeshBuilder new
			addUVSphereWithDiameter: 1.0 segments: 32 slices: 32;
			mesh);
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		openInWindow
]

{ #category : 'basic shapes' }
WDSceneExamples class >> exampleVideoPlayback [
	"
	self exampleVideoPlayback
	"
	| videoPlayer videoMaterial |
	videoPlayer := WDVideoPlayer new
		openWithUrl: 'bbb_sunflower_1080p_60fps_normal.mp4';
		yourself.

	videoMaterial := WDUnlitMaterial new
		colorTexture: videoPlayer playbackTexture.
 
	WDScene new
		add: (WDMeshBuilder new
			currentMaterial: videoMaterial;
			addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
			generateTexcoords0ForScreenProjection;
			mesh);
		add: ((WDPointLightSource new
			color: (Vector3 x: 0.8 y: 0.8 z: 0.2);
			intensity: 5.0;
			influenceRadius: 4.0;
			asSceneNode)
				position: (Vector3 x: -1.5 y: 1.5 z: 1.6);
				yourself);
		updateBlock: [ :delta | ];
		openInWindow
]

{ #category : 'see class side' }
WDSceneExamples >> seeClassSide [
]
