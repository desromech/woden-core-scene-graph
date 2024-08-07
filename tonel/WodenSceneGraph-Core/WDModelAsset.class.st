"
I encapsulate the content of particular model asset. I am used for encapsulating the following kinds of assets:

- Materials
- Textures
- Meshes
- Scenes
"
Class {
	#name : 'WDModelAsset',
	#superclass : 'Object',
	#instVars : [
		'scenes',
		'meshes',
		'materials',
		'textures',
		'elementSet',
		'nameDictionary',
		'skeletalMeshes',
		'animations',
		'skeletons'
	],
	#category : 'WodenSceneGraph-Core-Asset',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Asset'
}

{ #category : 'adding' }
WDModelAsset >> addAnimation: anAnimation [
	(elementSet includes: anAnimation) ifTrue: [ ^ self ].
	self privateAddElement: anAnimation.
	animations add: anAnimation
]

{ #category : 'adding' }
WDModelAsset >> addElementWithDependencies: anElement [
	(elementSet includes: anElement) ifTrue: [ ^ self ].
	anElement addIntoModelAssetWithDependencies: self
]

{ #category : 'adding' }
WDModelAsset >> addMaterial: aMaterial [
	(elementSet includes: aMaterial) ifTrue: [ ^ self ].
	self privateAddElement: aMaterial.
	materials add: aMaterial
]

{ #category : 'adding' }
WDModelAsset >> addMesh: aMesh [
	(elementSet includes: aMesh) ifTrue: [ ^ self ].
	self privateAddElement: aMesh.
	meshes add: aMesh
]

{ #category : 'adding' }
WDModelAsset >> addScene: aScene [
	(elementSet includes: aScene) ifTrue: [ ^ self ].
	self privateAddElement: aScene.
	aScene withChildrenDo: [ :eachNode |
		(eachNode name isNotNil and: [eachNode name isNotEmpty and: [(nameDictionary includesKey: eachNode name) not]]) ifTrue: [
			nameDictionary at: eachNode name put: eachNode
		]
	].
	scenes add: aScene
]

{ #category : 'adding' }
WDModelAsset >> addSkeletalMesh: aSkeletalMesh [
	(elementSet includes: aSkeletalMesh) ifTrue: [ ^ self ].
	self privateAddElement: aSkeletalMesh.
	skeletalMeshes add: aSkeletalMesh
]

{ #category : 'adding' }
WDModelAsset >> addSkeleton: aSkeleton [
	(elementSet includes: aSkeleton) ifTrue: [ ^ self ].
	self privateAddElement: aSkeleton.
	skeletons add: aSkeleton
]

{ #category : 'adding' }
WDModelAsset >> addTexture: aTexture [
	(elementSet includes: aTexture) ifTrue: [ ^ self ].
	self privateAddElement: aTexture.
	textures add: aTexture
]

{ #category : 'accessing' }
WDModelAsset >> animations [
	^ animations
]

{ #category : 'lookup elements' }
WDModelAsset >> elementNamed: aName [
	^ nameDictionary at: aName
]

{ #category : 'as yet unclassified' }
WDModelAsset >> getCollisionShapeNamed: collisionElementName [
	| collisionElement boundingBox |
	collisionElement := self renderableOrSceneElementNamed: collisionElementName.
	collisionElement ifNil: [ ^ nil ].
	
	(collisionElement isWodenRenderable or: [ collisionElement isWodenSceneElement ]) ifFalse: [ ^ nil ].
	boundingBox := collisionElement boundingBox.
	
	^ WDConvexHullCollisionShape withPoints: boundingBox corners.
]

{ #category : 'initialization' }
WDModelAsset >> initialize [
	super initialize.
	elementSet := Set new.
	nameDictionary := Dictionary new.
	textures := OrderedCollection new.
	materials := OrderedCollection new.
	meshes := OrderedCollection new.
	skeletalMeshes := OrderedCollection new.
	skeletons := OrderedCollection new.
	scenes := OrderedCollection new.
	animations := OrderedCollection new.
	
]

{ #category : 'as yet unclassified' }
WDModelAsset >> instanceDefaultSceneNode [
	scenes isEmpty ifFalse: [
		^ scenes first instanceAsSceneNode
	].

	meshes isEmpty ifFalse: [
		^ meshes first instanceAsSceneNode
	].

	^ nil
]

{ #category : 'as yet unclassified' }
WDModelAsset >> instanceSceneNodeForElementNamed: elementName [
	| element |
	element := self renderableOrSceneElementNamed: elementName.
	element isWodenSceneElement ifTrue: [ ^ element instanceAsSceneNode ].
	element isWodenRenderable ifFalse: [ ^ element asSceneNode ].
	^ nil
]

{ #category : 'accessing' }
WDModelAsset >> materials [

	^ materials
]

{ #category : 'accessing' }
WDModelAsset >> meshes [

	^ meshes
]

{ #category : 'private' }
WDModelAsset >> privateAddElement: anElement [
	elementSet add: anElement.
	(anElement name notNil and: [anElement name isEmpty not]) ifTrue: [ 
		nameDictionary at: anElement name put: anElement
	]
]

{ #category : 'as yet unclassified' }
WDModelAsset >> renderableOrSceneElementNamed: name [
	(name isNil or: [name isEmpty]) ifTrue: [ 
		scenes isEmpty ifFalse: [
			^ scenes first
		].

		meshes isEmpty ifFalse: [
			^ meshes first
		].
	].

	^ nameDictionary at: name ifAbsent: [ nil ]
]

{ #category : 'accessing' }
WDModelAsset >> scenes [

	^ scenes
]

{ #category : 'accessing' }
WDModelAsset >> skeletalMeshes [

	^ skeletalMeshes
]

{ #category : 'accessing' }
WDModelAsset >> skeletons [
	^ skeletons
]

{ #category : 'accessing' }
WDModelAsset >> textures [

	^ textures
]
