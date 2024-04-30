Class {
	#name : #WDConvexHullCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'points'
	],
	#category : #'WodenSceneGraph-Core-Collision'
}

{ #category : #construction }
WDConvexHullCollisionShape class >> withPoints: aListOfPoints [
	^ self new points: aListOfPoints; yourself
]

{ #category : #adding }
WDConvexHullCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithBox: self localBoundingBox;
			mesh) asSceneNode
]

{ #category : #'intersection testing' }
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

{ #category : #accessing }
WDConvexHullCollisionShape >> points [

	^ points
]

{ #category : #accessing }
WDConvexHullCollisionShape >> points: aListOfPoints [
	points := aListOfPoints.
	self localBoundingBox: (AABox encompassing: points).
]

{ #category : #transforming }
WDConvexHullCollisionShape >> transformedWith: aTransform [
	aTransform isIdentity ifTrue: [ ^ self ].
	
	^ self class withPoints: (points collect: [:eachPoint |
		aTransform transformPosition: eachPoint
	])
]
