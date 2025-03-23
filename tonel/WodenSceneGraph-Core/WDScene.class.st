"
I am Woden 3D graphics scene.

I provide a logical description of elements in a 3D graphical scene, along with facilities for fast traversal of elements distributed in a bounding volume such as a frustum to facilitate actual rendering.
"
Class {
	#name : 'WDScene',
	#superclass : 'WDSceneElement',
	#instVars : [
		'backgroundLayer',
		'normalLayer',
		'foregroundLayer',
		'updateBlock',
		'globalLightingState'
	],
	#category : 'WodenSceneGraph-Core-Scene',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Scene'
}

{ #category : 'adding' }
WDScene >> add: aNode [
	normalLayer add: aNode
]

{ #category : 'adding' }
WDScene >> addBackground: aNode [
	backgroundLayer add: aNode
]

{ #category : 'adding' }
WDScene >> addForeground: aNode [
	foregroundLayer add: aNode
]

{ #category : 'accessing' }
WDScene >> ambientLightProbe: aWDLightProbe [
	globalLightingState ambientLightProbe: aWDLightProbe
]

{ #category : 'accessing' }
WDScene >> ambientLighting [
	^ globalLightingState ambientLighting
]

{ #category : 'accessing' }
WDScene >> ambientLighting: aLightingColor [
	globalLightingState ambientLighting: aLightingColor
]

{ #category : 'converting' }
WDScene >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		globalLightingState: globalLightingState copy;
		cameraLayers: { 
			backgroundLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
			normalLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
			foregroundLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
		};
		yourself.
		
		 
]

{ #category : 'accessing' }
WDScene >> backgroundLayer [

	^ backgroundLayer
]

{ #category : 'accessing' }
WDScene >> boundingBox [
	^ self normalLayer boundingBox
]

{ #category : 'accessing' }
WDScene >> children [
	^ { backgroundLayer . normalLayer . foregroundLayer }
]

{ #category : 'accessing' }
WDScene >> exportToGltf: aFileReference [
	| builder json rootNodes |
	builder := WDSRWGLTF2Builder new.
	rootNodes := normalLayer children collect: [ :each | each exportToGltfWith: builder] as: Array.
	(builder newScene: name) nodes: rootNodes.
	json := builder buildJson.

	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: json ]
]

{ #category : 'accessing' }
WDScene >> foregroundLayer [

	^ foregroundLayer
]

{ #category : 'accessing' }
WDScene >> globalLightingState [
	^ globalLightingState
]

{ #category : 'accessing' }
WDScene >> globalLightingState: aGlobalLightingState [
	globalLightingState := aGlobalLightingState
]

{ #category : 'initialization' }
WDScene >> initialize [
	super initialize.
	globalLightingState := WDGlobalLightingState default.
	backgroundLayer := WDBackgroundSceneLayer for: self.
	normalLayer := WDNormalSceneLayer for: self.
	foregroundLayer := WDForegroundSceneLayer for: self.
	updateBlock := [ :delta | false ].
]

{ #category : 'copying' }
WDScene >> instanceAsSceneNode [
	^ self normalLayer instanceAsSceneNode
]

{ #category : 'testing' }
WDScene >> isScene [
	^ true
]

{ #category : 'accessing' }
WDScene >> normalLayer [

	^ normalLayer
]

{ #category : 'accessing' }
WDScene >> parent [
	^ nil
]

{ #category : 'copying' }
WDScene >> postCopy [
	super postCopy.
	updateBlock := [ :delta | false ].
	backgroundLayer := backgroundLayer copy copiedIntoScene: self; yourself.
	normalLayer := normalLayer copy copiedIntoScene: self; yourself.
	foregroundLayer := foregroundLayer copy copiedIntoScene: self; yourself.
	
]

{ #category : 'adding' }
WDScene >> remove: aNode [
	normalLayer remove: aNode
]

{ #category : 'accessing' }
WDScene >> scene [
	^ self
]

{ #category : 'accessing' }
WDScene >> updateBlock [

	^ updateBlock
]

{ #category : 'accessing' }
WDScene >> updateBlock: anObject [

	updateBlock := anObject
]

{ #category : 'update' }
WDScene >> updateWithDeltaTime: deltaTime [
	^ (updateBlock cull: deltaTime) ~~ false
]
