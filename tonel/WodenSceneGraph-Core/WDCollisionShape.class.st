"
I represent a specific collision shape.
"
Class {
	#name : 'WDCollisionShape',
	#superclass : 'Object',
	#instVars : [
		'margin',
		'localBoundingBox',
		'localBoundingBoxWithMargin'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'testing' }
WDCollisionShape class >> isAbstract [
	^ self == WDCollisionShape
]

{ #category : 'mass distribution' }
WDCollisionShape >> computeInertiaTensorWithMass: mass [
	^ Matrix3x3 zeros
]

{ #category : 'adding' }
WDCollisionShape >> constructVisualizationSceneNode [
	^ self subclassResponsibility
]

{ #category : 'collision detection' }
WDCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : 'collision detection' }
WDCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : 'collision detection' }
WDCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : 'collision detection' }
WDCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withHeightfieldShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : 'initialization' }
WDCollisionShape >> initialize [
	super initialize.
	margin := 0.01.
	localBoundingBox := AABox new.
	localBoundingBoxWithMargin := nil.
]

{ #category : 'testing' }
WDCollisionShape >> isCompoundCollisionShape [
	^ false
]

{ #category : 'testing' }
WDCollisionShape >> isEmptyShape [
	^ false
]

{ #category : 'as yet unclassified' }
WDCollisionShape >> localBoundaryCorners [
	^ #()
]

{ #category : 'accessing' }
WDCollisionShape >> localBoundingBox [

	^ localBoundingBox
]

{ #category : 'accessing' }
WDCollisionShape >> localBoundingBox: anAABox [
	localBoundingBox := anAABox.
	localBoundingBoxWithMargin := nil.
]

{ #category : 'accessing' }
WDCollisionShape >> localBoundingBoxWithMargin [
	^ localBoundingBoxWithMargin ifNil: [ localBoundingBoxWithMargin := self localBoundingBox withExpandedHalfExtent: margin ]
]

{ #category : 'accessing' }
WDCollisionShape >> margin [

	^ margin
]

{ #category : 'accessing' }
WDCollisionShape >> margin: aNumber [
	margin := aNumber.
	localBoundingBoxWithMargin := nil.
]

{ #category : 'testing' }
WDCollisionShape >> rayCast: ray [
	self subclassResponsibility
]

{ #category : 'transforming' }
WDCollisionShape >> transformedWith: aTransform [
	aTransform isIdentity ifTrue: [ ^ self ].

	^ WDCompoundCollisionShape new
		addShape: self withTransform: aTransform;
		yourself
]

{ #category : 'testing' }
WDCollisionShape >> withTransform: shapeTransform intersectsBox: box withTransform: boxTransform [
	^ false
]

{ #category : 'testing' }
WDCollisionShape >> withTransform: shapeTransform intersectsSphere: sphere [
	^ self withTransform: shapeTransform intersectsSphere: sphere withTransform: ReversibleAffineTransform3D identity
]

{ #category : 'testing' }
WDCollisionShape >> withTransform: shapeTransform intersectsSphere: sphere withTransform: sphereTransform [
	^ false
]
