"
I represent an arbitrary element in the logical description of a scene.
"
Class {
	#name : 'WDSceneElement',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'WodenSceneGraph-Core-Scene',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Scene'
}

{ #category : 'testing' }
WDSceneElement class >> isAbstract [
	^ self == WDSceneElement
]

{ #category : 'converting' }
WDSceneElement >> asRenderingSceneWithCameraState: baseCameraState [
	self subclassResponsibility
]

{ #category : 'converting' }
WDSceneElement >> asSceneElement [
	^ self
]

{ #category : 'hook' }
WDSceneElement >> childBoundingBoxChanged: aChild [
	
]

{ #category : 'accessing' }
WDSceneElement >> children [
	self subclassResponsibility
]

{ #category : 'accessing' }
WDSceneElement >> globalTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : 'copying' }
WDSceneElement >> instanceAsSceneNode [
	^ self subclassResponsibility
]

{ #category : 'testing' }
WDSceneElement >> isBackgroundSceneLayer [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isForegroundSceneLayer [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isNormalSceneLayer [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isScene [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isSceneLayer [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isSceneNode [
	^ false
]

{ #category : 'testing' }
WDSceneElement >> isWodenSceneElement [
	^ true
]

{ #category : 'accessing' }
WDSceneElement >> name [

	^ name
]

{ #category : 'accessing' }
WDSceneElement >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSceneElement >> parent [
	self subclassResponsibility
]

{ #category : 'accessing' }
WDSceneElement >> scene [
	^ nil
]

{ #category : 'accessing' }
WDSceneElement >> sceneLayer [
	^ nil
]

{ #category : 'update' }
WDSceneElement >> updateWithDeltaTime: deltaTime [
	^ false
]

{ #category : 'enumerating' }
WDSceneElement >> withChildrenDo: aBlock [
	aBlock value: self.
	self children do: [ :each |
		each withChildrenDo: aBlock
	]
]
