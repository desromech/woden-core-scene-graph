"
I represent a single contact point in a contact manifold.
"
Class {
	#name : 'WDContactPoint',
	#superclass : 'Object',
	#instVars : [
		'epoch',
		'normal',
		'firstCollisionObject',
		'secondCollisionObject',
		'requiredSeparation',
		'firstPoint',
		'secondPoint',
		'localFirstPoint',
		'localSecondPoint',
		'localFirstNormal',
		'localSecondNormal',
		'penetrationDistance'
	],
	#classVars : [
		'PointEpsilon'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'class initialization' }
WDContactPoint class >> initialize [
	PointEpsilon := 0.001.
]

{ #category : 'accessing' }
WDContactPoint >> closingSpeed [
	^ self separationSpeed negated
]

{ #category : 'contact resolution' }
WDContactPoint >> computeContactSpaceMatrix [
	| x y z |
	x := normal.
	y := normal x abs > normal y abs
		ifTrue: [ Vector3 y: 1]
		ifFalse: [ Vector3 x: 1 ].

	z := (x cross: y) normalized.
	y := (z cross: x) normalized.
	
	^ Matrix3x3 columns: { x . y . z }

]

{ #category : 'updating' }
WDContactPoint >> computeLocalVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	localFirstPoint := firstTransform inverseTransformPosition: firstPoint.
	localSecondPoint := secondTransform inverseTransformPosition: secondPoint.
	localFirstNormal := firstTransform inverseTransformNormalVector: (secondTransform inverseTransformNormalVector: normal).
	localSecondNormal := secondTransform inverseTransformNormalVector: (firstTransform inverseTransformNormalVector: normal negated).
]

{ #category : 'updating' }
WDContactPoint >> computeWorldContactPointAndDistances [
	penetrationDistance := requiredSeparation + (secondPoint - firstPoint dot: normal).
	
]

{ #category : 'updating' }
WDContactPoint >> computeWorldVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	firstPoint := firstTransform transformPosition: localFirstPoint.
	secondPoint := secondTransform transformPosition: localSecondPoint.
	normal := firstTransform transformNormalVector: (secondTransform transformNormalVector: localFirstNormal).
	self computeWorldContactPointAndDistances.
]

{ #category : 'accessing' }
WDContactPoint >> epoch [

	^ epoch
]

{ #category : 'accessing' }
WDContactPoint >> epoch: anObject [

	epoch := anObject
]

{ #category : 'accessing' }
WDContactPoint >> firstCollisionObject [

	^ firstCollisionObject
]

{ #category : 'accessing' }
WDContactPoint >> firstCollisionObject: anObject [

	firstCollisionObject := anObject
]

{ #category : 'accessing' }
WDContactPoint >> firstObjectHasResponse [
	^ firstCollisionObject collisionResponseGroupMask anyMask: secondCollisionObject collisionGroup
]

{ #category : 'accessing' }
WDContactPoint >> firstPoint [

	^ firstPoint
]

{ #category : 'accessing' }
WDContactPoint >> firstPoint: anObject [

	firstPoint := anObject
]

{ #category : 'updating' }
WDContactPoint >> flipped [
	^ self copy
		normal: normal negated;
		firstPoint: secondPoint;
		secondPoint: firstPoint;
		localFirstNormal: localSecondNormal;
		localSecondNormal: localFirstNormal;
		localFirstPoint: localSecondPoint;
		localSecondPoint: localFirstPoint;
		yourself
]

{ #category : 'testing' }
WDContactPoint >> hasCollisionResponse [
	^ self firstObjectHasResponse or: [self secondObjectHasResponse]
]

{ #category : 'accessing' }
WDContactPoint >> inverseAngularInertia [
	^ (firstCollisionObject computeAngularInertiaForRelativeContactPoint: self relativeFirstPoint normal: normal) + (secondCollisionObject computeAngularInertiaForRelativeContactPoint: self relativeFirstPoint normal: normal)
]

{ #category : 'accessing' }
WDContactPoint >> inverseInertia [
	^ self inverseLinearInertia + self inverseAngularInertia
]

{ #category : 'accessing' }
WDContactPoint >> inverseLinearInertia [
	^ firstCollisionObject inverseMass + secondCollisionObject inverseMass
]

{ #category : 'accessing' }
WDContactPoint >> inverseMass [
	^ firstCollisionObject inverseMass + secondCollisionObject inverseMass
]

{ #category : 'testing' }
WDContactPoint >> isSimilarTo: otherContact [
	^ (localFirstPoint closeTo: otherContact localFirstPoint precision: PointEpsilon) and: [ 
		(localSecondPoint closeTo: otherContact localSecondPoint precision: PointEpsilon)
	]
]

{ #category : 'accessing' }
WDContactPoint >> localFirstNormal [

	^ localFirstNormal
]

{ #category : 'accessing' }
WDContactPoint >> localFirstNormal: anObject [

	localFirstNormal := anObject
]

{ #category : 'accessing' }
WDContactPoint >> localFirstPoint [

	^ localFirstPoint
]

{ #category : 'accessing' }
WDContactPoint >> localFirstPoint: anObject [

	localFirstPoint := anObject
]

{ #category : 'accessing' }
WDContactPoint >> localSecondNormal [

	^ localSecondNormal
]

{ #category : 'accessing' }
WDContactPoint >> localSecondNormal: anObject [

	localSecondNormal := anObject
]

{ #category : 'accessing' }
WDContactPoint >> localSecondPoint [

	^ localSecondPoint
]

{ #category : 'accessing' }
WDContactPoint >> localSecondPoint: anObject [

	localSecondPoint := anObject
]

{ #category : 'accessing' }
WDContactPoint >> normal [

	^ normal
]

{ #category : 'accessing' }
WDContactPoint >> normal: anObject [

	normal := anObject
]

{ #category : 'accessing' }
WDContactPoint >> penetrationDistance [

	^ penetrationDistance
]

{ #category : 'accessing' }
WDContactPoint >> penetrationDistance: anObject [

	penetrationDistance := anObject
]

{ #category : 'accessing' }
WDContactPoint >> point [
	^ firstPoint + ((secondPoint - firstPoint) * 0.5)
]

{ #category : 'printing' }
WDContactPoint >> printOn: aStream [
	aStream nextPutAll: 'normal: '; print: normal; nextPutAll: ' pd: '; print: penetrationDistance
]

{ #category : 'as yet unclassified' }
WDContactPoint >> relativeFirstPoint [
	^ firstPoint - firstCollisionObject position
]

{ #category : 'as yet unclassified' }
WDContactPoint >> relativeSecondPoint [
	^ secondPoint - secondCollisionObject position
]

{ #category : 'accessing' }
WDContactPoint >> requiredSeparation [

	^ requiredSeparation
]

{ #category : 'accessing' }
WDContactPoint >> requiredSeparation: anObject [

	requiredSeparation := anObject
]

{ #category : 'accessing' }
WDContactPoint >> secondCollisionObject [

	^ secondCollisionObject
]

{ #category : 'accessing' }
WDContactPoint >> secondCollisionObject: anObject [

	secondCollisionObject := anObject
]

{ #category : 'accessing' }
WDContactPoint >> secondObjectHasResponse [
	^ secondCollisionObject collisionResponseGroupMask anyMask: firstCollisionObject collisionGroup
]

{ #category : 'accessing' }
WDContactPoint >> secondPoint [

	^ secondPoint
]

{ #category : 'accessing' }
WDContactPoint >> secondPoint: anObject [

	secondPoint := anObject
]

{ #category : 'accessing' }
WDContactPoint >> separationSpeed [
	^ (firstCollisionObject velocityAtRelativePoint: self relativeFirstPoint) - (secondCollisionObject velocityAtRelativePoint: self relativeSecondPoint) dot: normal
]

{ #category : 'updating' }
WDContactPoint >> update [
	self computeWorldVersionWithFirstTransform: firstCollisionObject transform secondTransform: secondCollisionObject transform
]
