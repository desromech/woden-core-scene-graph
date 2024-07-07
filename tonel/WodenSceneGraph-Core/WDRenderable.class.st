"
I am an object that can be rendered on 3D graphics scene.
"
Class {
	#name : 'WDRenderable',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'adding' }
WDRenderable >> addIntoAnimationSubtreeMap: subtreeMap [
]

{ #category : 'adding' }
WDRenderable >> addIntoModelAssetWithDependencies: modelAsset [
	"By default do nothing"
]

{ #category : 'adding' }
WDRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	self subclassResponsibility
]

{ #category : 'adding' }
WDRenderable >> addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState [
	self subclassResponsibility
]

{ #category : 'converting' }
WDRenderable >> asSceneElement [
	^ self asSceneNode
]

{ #category : 'converting' }
WDRenderable >> asSceneNode [
	^ WDSceneNode new
		renderables: { self };
		yourself
]

{ #category : 'accessing' }
WDRenderable >> boundingBox [
	^ AABox originPoint
]

{ #category : 'copying' }
WDRenderable >> copyTransformingMaterialsWith: aBlock [
	self subclassResponsibility
]

{ #category : 'copying' }
WDRenderable >> copyWithMaterial: aMaterial [
	self subclassResponsibility
]

{ #category : 'double dispatch' }
WDRenderable >> emitRenderingCommandsWithRenderer: renderer [
]

{ #category : 'initialization' }
WDRenderable >> initialize [
	super initialize.
	name := ''.
]

{ #category : 'testing' }
WDRenderable >> isWodenRenderable [
	^ true
]

{ #category : 'accessing' }
WDRenderable >> name [

	^ name
]

{ #category : 'accessing' }
WDRenderable >> name: anObject [

	name := anObject
]
