"
I am a hierarchical scene element that implements methods for manipulating its tree.
"
Class {
	#name : #WDSceneTreeElement,
	#superclass : #WDSceneElement,
	#instVars : [
		'parent'
	],
	#category : #'WodenSceneGraph-Core-Scene'
}

{ #category : #adding }
WDSceneTreeElement >> addRecursivelyIntoRenderingSceneCameraLayer: renderingSceneCameraLayer parentGlobalTransform: parentGlobalTransform [
	self subclassResponsibility
]

{ #category : #internal }
WDSceneTreeElement >> addedTo: newParent [
	self assert: parent isNil.
	parent := newParent.
]

{ #category : #converting }
WDSceneTreeElement >> asRenderingSceneCameraLayerWithCameraState: baseCameraState [
	| result |
	result := WDRenderingSceneCameraLayer new
		cameraState: baseCameraState;
		yourself.
	self addRecursivelyIntoRenderingSceneCameraLayer: result parentGlobalTransform: ReversibleAffineTransform3D identity.
	^ result
]

{ #category : #converting }
WDSceneTreeElement >> asRenderingSceneWithCameraState: baseCameraState [
	^ WDRenderingScene new
		mainCameraState: baseCameraState;
		globalLightingState: WDGlobalLightingState defaultForInspector;
		cameraLayers: { 
			self asRenderingSceneCameraLayerWithCameraState: baseCameraState
		};
		yourself.
]

{ #category : #accessing }
WDSceneTreeElement >> parent [

	^ parent
]

{ #category : #accessing }
WDSceneTreeElement >> parent: anObject [

	parent := anObject
]

{ #category : #adding }
WDSceneTreeElement >> remove: aNode [
	self removeSceneElement: aNode
]

{ #category : #internal }
WDSceneTreeElement >> removedFrom: oldParent [
	self assert: parent == oldParent.
	parent := nil.
]

{ #category : #internal }
WDSceneTreeElement >> scene [
	^ parent ifNotNil: [ parent scene ]
]

{ #category : #internal }
WDSceneTreeElement >> sceneLayer [
	^ parent ifNotNil: [ parent sceneLayer ]
]
