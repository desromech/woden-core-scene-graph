"
I am Woden 3D graphics scene.

I provide a logical description of elements in a 3D graphical scene, along with facilities for fast traversal of elements distributed in a bounding volume such as a frustum to facilitate actual rendering.
"
Class {
	#name : #WDScene,
	#superclass : #WDSceneElement,
	#instVars : [
		'backgroundLayer',
		'normalLayer',
		'foregroundLayer'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDScene >> add: aNode [
	normalLayer add: aNode
]

{ #category : #converting }
WDScene >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		cameraLayers: { 
			backgroundLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
			normalLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
			foregroundLayer asRenderingSceneCameraLayerWithCameraState: baseCameraState.
		};
		yourself.
		
		 
]

{ #category : #accessing }
WDScene >> backgroundLayer [

	^ backgroundLayer
]

{ #category : #accessing }
WDScene >> children [
	^ { backgroundLayer . normalLayer . foregroundLayer }
]

{ #category : #accessing }
WDScene >> foregroundLayer [

	^ foregroundLayer
]

{ #category : #initialization }
WDScene >> initialize [
	super initialize.
	backgroundLayer := WDBackgroundSceneLayer for: self.
	normalLayer := WDNormalSceneLayer for: self.
	foregroundLayer := WDForegroundSceneLayer for: self.
]

{ #category : #testing }
WDScene >> isScene [
	^ true
]

{ #category : #accessing }
WDScene >> normalLayer [

	^ normalLayer
]

{ #category : #accessing }
WDScene >> parent [
	^ nil
]

{ #category : #adding }
WDScene >> remove: aNode [
	normalLayer remove: aNode
]

{ #category : #accessing }
WDScene >> scene [
	^ self
]
