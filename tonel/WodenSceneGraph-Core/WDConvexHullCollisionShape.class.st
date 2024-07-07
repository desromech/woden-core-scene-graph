Class {
	#name : 'WDConvexHullCollisionShape',
	#superclass : 'WDConvexCollisionShape',
	#instVars : [
		'points',
		'baseInertiaTensor'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'construction' }
WDConvexHullCollisionShape class >> withPoints: aListOfPoints [
	^ self new points: aListOfPoints; yourself
]

{ #category : 'mass distribution' }
WDConvexHullCollisionShape >> baseInertiaTensor [
	baseInertiaTensor ifNotNil: [ ^ baseInertiaTensor ].
	
	"Approximate the convex hull inertia by using the bounding box."
	^ baseInertiaTensor :=
		(Matrix3x3 inertiaTensorForBoxWithHalfExtent: self localBoundingBox halfExtent)
		+ (Matrix3x3 inertiaTensorTransport: self localBoundingBox center).
]

{ #category : 'mass distribution' }
WDConvexHullCollisionShape >> computeInertiaTensorWithMass: mass [
	^ self baseInertiaTensor * mass
]

{ #category : 'adding' }
WDConvexHullCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithBox: self localBoundingBox;
			mesh) asSceneNode
]

{ #category : 'as yet unclassified' }
WDConvexHullCollisionShape >> localBoundaryCorners [
	^ points
]

{ #category : 'intersection testing' }
WDConvexHullCollisionShape >> localSupportInDirection: aDirection [
	| bestDistance bestFound |
	bestDistance := Float negativeInfinity.
	bestFound := Vector3 zeros.
	points do: [ :each |
		| distance |
		distance := each dot: aDirection.
		distance > bestDistance ifTrue: [ 
			bestDistance := distance.
			bestFound := each.
		]
	].

	^ bestFound
]

{ #category : 'accessing' }
WDConvexHullCollisionShape >> points [

	^ points
]

{ #category : 'accessing' }
WDConvexHullCollisionShape >> points: aListOfPoints [
	points := aListOfPoints.
	self localBoundingBox: (AABox encompassing: points).
	baseInertiaTensor := nil.
]

{ #category : 'transforming' }
WDConvexHullCollisionShape >> transformedWith: aTransform [
	aTransform isIdentity ifTrue: [ ^ self ].
	
	^ self class withPoints: (points collect: [:eachPoint |
		aTransform transformPosition: eachPoint
	])
]
