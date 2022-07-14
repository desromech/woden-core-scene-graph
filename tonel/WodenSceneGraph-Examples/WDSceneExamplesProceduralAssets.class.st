"
I hold a collection of procedurally generated assets.
"
Class {
	#name : #WDSceneExamplesProceduralAssets,
	#superclass : #Object,
	#instVars : [
		'tileMaterial',
		'checkboardMaterial',
		'checkboardTexture',
		'checkboardNormalTexture',
		'poolWaterMaterial'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenSceneGraph-Examples'
}

{ #category : #'instance creation' }
WDSceneExamplesProceduralAssets class >> new [
	self shouldNotImplement
]

{ #category : #compiling }
WDSceneExamplesProceduralAssets class >> noteCompilationOf: aSelector meta: isMeta [
	isMeta ifFalse: [ 
		(uniqueInstance notNil and: [ self hasInstVarNamed: aSelector ]) ifTrue: [
			uniqueInstance instVarNamed: aSelector put: nil
		].
	].

	super noteCompilationOf: aSelector meta: isMeta
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets class >> reset [
	<script>
	uniqueInstance := nil.
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets >> checkboardMaterial [
	<script: 'self uniqueInstance checkboardMaterial inspect'>
	checkboardMaterial ifNotNil: [ ^ checkboardMaterial ].
	^ checkboardMaterial := WDMetallicRoughnessMaterial new
		roughnessFactor: 0.3;
		metallicFactor: 0.0;
		baseColorTexture: self checkboardTexture;
		normalTexture: self checkboardNormalTexture;
		yourself.
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets >> checkboardNormalTexture [
	<script: 'self uniqueInstance checkboardNormalTexture inspect'>
	| form |
	checkboardNormalTexture ifNotNil: [ ^ checkboardNormalTexture ].
	form := (FPLFormRenderer extent: 128@128)
		renderGray: [:x :y |
			| xp yp |
			xp := (x * 5.0) floorFractionPart < 0.5.
			yp := (y * 5.0) floorFractionPart < 0.5.
			(xp xor: yp) asBit
		];
		intoNormalMapWithXScale: 1.0 yScale: 1.0 heightScale: 1.0 gradientOperator: FPLGradientOperator sobel3x3;
		form.
	
	^ checkboardNormalTexture := WDTexture forNormalMapForm: form
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets >> checkboardTexture [
	<script: 'self uniqueInstance checkboardTexture inspect'>
	| form |
	checkboardTexture ifNotNil: [ ^ checkboardTexture ].
	form := (FPLFormRenderer extent: 128@128)
		renderGray: [:x :y |
			| xp yp |
			xp := (x * 5.0) floorFractionPart < 0.5.
			yp := (y * 5.0) floorFractionPart < 0.5.
			(xp xor: yp) asBit
		];
		form.
	
	^ checkboardTexture := WDTexture forColorForm: form
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets >> poolWaterMaterial [
	<script: 'self uniqueInstance poolWaterMaterial inspect'>
	| extent height normalMapForm |
	poolWaterMaterial ifNotNil: [ ^ poolWaterMaterial ].

	extent := 256@256.

	height := [ :x :y |
		| position |
		position := Vector2 x: x y: y.
		(position * 5) voronoiTurbulenceScales: 3 tiledWith: 5 asVector2
	].


	normalMapForm := (FPLFormRenderer extent: extent)
		renderGray: height;
		intoNormalMapWithScale: 2.0 gradientOperator: FPLGradientOperator sobel3x3;
		form.

	^ poolWaterMaterial := WDDuplicatedMetallicRoughnessLiquidMaterial new
		alphaMode: #BLEND;
		doubleSided: true;
		roughnessFactor: 0.02;
		metallicFactor: 0.0;
		baseColorFactor: (Vector4 x: 0.0 y: 0.0 z: 0.0 w: 0.05);
		normalTexture: (WDTexture forNormalMapForm: normalMapForm);
		texcoordOffsetVelocity: (Vector2 withAll: 0.3);
		duplicatedTexcoordOffsetVelocity: (Vector2 withAll: -0.3);
		yourself
]

{ #category : #accessing }
WDSceneExamplesProceduralAssets >> tileMaterial [
	<script: 'self uniqueInstance tileMaterial inspect'>
	| cutoff cutoffStart tileColor infillColor darkerTileColor extent interior inside height baseColorForm normalMapForm |
	tileMaterial ifNotNil: [ ^ tileMaterial ].

	cutoff := 0.05.
	cutoffStart := cutoff * 0.33.
	tileColor := Color fromHexString: '#AE7986'.
	infillColor := Color fromHexString: '#372B33'.
	darkerTileColor := (Color fromHexString: '#C66270') darker.
	extent := 256@256.

	interior := [ :x :y |
		| position |
		position := ((Vector2 x: x y: y) - 0.5) *2.0.
		1.0 - position infiniteNorm
	].

	inside := [ :x :y |
		(interior value: x value: y) smoothStepFrom: cutoff * 0.80 to: cutoff *1.2
	].

	height := [ :x :y |
		| geometry noise noiseScale inFilling fillingNoiseScale fillingNoise |
		geometry := ((interior value: x value: y) min: cutoff max: cutoffStart) - cutoffStart / (cutoff - cutoffStart).

		noiseScale := 10.
		noise := ((Vector2 x: x y: y) * noiseScale) turbulenceTiledWith: noiseScale asVector2.

		inFilling := 1.0 - (inside value: x value: y).
		fillingNoiseScale := 50.
		fillingNoise := ((Vector2 x: x y: y) * fillingNoiseScale) turbulenceTiledWith: fillingNoiseScale asVector2.

		geometry*0.8 + (noise*0.2) + (fillingNoise abs *0.7 * inFilling).
	].

	"
	(FPLFormRenderer extent: extent)
		renderGray: height;
		form.
	"	
	baseColorForm := (FPLFormRenderer extent: extent)
		renderColor: [:x :y |
			| interiorColor noise |
			noise := ((Vector2 x: x y: y) * 7) turbulenceTiledWith: 7 asVector2.
			interiorColor := tileColor interpolateTo: darkerTileColor at: (noise *0.5 + 0.5).
			infillColor interpolateTo: interiorColor at: (inside value: x value: y)
		];
		form.
	normalMapForm := (FPLFormRenderer extent: extent)
		renderGray: height;
		intoNormalMapWithScale: 4.0 gradientOperator: FPLGradientOperator sobel3x3;
		form.

	^ tileMaterial := WDMetallicRoughnessMaterial new
		baseColorTexture: (WDTexture forColorForm: baseColorForm);
		normalTexture: (WDTexture forNormalMapForm: normalMapForm);
		metallicFactor: 0.0;
		roughnessFactor: 0.5;
		yourself
]
