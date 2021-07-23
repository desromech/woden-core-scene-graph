"
A WDSceneTest is a test class for testing the behavior of WDScene
"
Class {
	#name : #WDSceneTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Tests'
}

{ #category : #tests }
WDSceneTest >> testAddNode [
	| scene node|
	scene := WDScene new.
	node := WDSceneNode new.
	self assert: node parent isNil.
	self assert: node sceneLayer isNil.
	self assert: node scene isNil.
	
	scene normalLayer add: node.
	self assert: node parent equals: scene normalLayer.
	self assert: node sceneLayer equals: scene normalLayer.
	self assert: node scene equals: scene.
	
	self assert: node scene normalLayer children size equals: 1.
	self assert: node scene normalLayer children first equals: node.
]

{ #category : #tests }
WDSceneTest >> testAddNode2 [
	| scene node|
	scene := WDScene new.
	node := WDSceneNode new.
	self assert: node parent isNil.
	self assert: node sceneLayer isNil.
	self assert: node scene isNil.
	
	scene add: node.
	self assert: node parent equals: scene normalLayer.
	self assert: node sceneLayer equals: scene normalLayer.
	self assert: node scene equals: scene.
	
	self assert: node scene normalLayer children size equals: 1.
	self assert: node scene normalLayer children first equals: node.
]

{ #category : #tests }
WDSceneTest >> testNew [
	| scene |
	scene := WDScene new.
	self assert: scene backgroundLayer isSceneLayer.
	self assert: scene backgroundLayer children isEmpty.
	
	self assert: scene normalLayer isSceneLayer.
	self assert: scene normalLayer children isEmpty.
	
	self assert: scene foregroundLayer isSceneLayer.
	self assert: scene foregroundLayer children isEmpty.
]

{ #category : #tests }
WDSceneTest >> testRemoveNode [
	| scene node|
	scene := WDScene new.
	node := WDSceneNode new.
	scene normalLayer add: node.
	scene normalLayer remove: node.

	self assert: scene normalLayer children isEmpty.
	
	self assert: node parent isNil.
	self assert: node sceneLayer isNil.
	self assert: node scene isNil.

]

{ #category : #tests }
WDSceneTest >> testRemoveNode2 [
	| scene node|
	scene := WDScene new.
	node := WDSceneNode new.
	scene add: node.
	scene remove: node.

	self assert: scene normalLayer children isEmpty.
	
	self assert: node parent isNil.
	self assert: node sceneLayer isNil.
	self assert: node scene isNil.

]

{ #category : #tests }
WDSceneTest >> testRemoveNode3 [
	| scene node|
	scene := WDScene new.
	node := WDSceneNode new.
	scene add: node.
	node removeFromScene.

	self assert: scene normalLayer children isEmpty.
	
	self assert: node parent isNil.
	self assert: node sceneLayer isNil.
	self assert: node scene isNil.

]
