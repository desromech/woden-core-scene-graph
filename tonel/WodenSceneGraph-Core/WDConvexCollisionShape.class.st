"
I represent a convex collision shape.
"
Class {
	#name : 'WDConvexCollisionShape',
	#superclass : 'WDCollisionShape',
	#classVars : [
		'ShallowPenetrationThreshold'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'initialization' }
WDConvexCollisionShape class >> initialize [
	ShallowPenetrationThreshold := 1e-5.
]

{ #category : 'testing' }
WDConvexCollisionShape class >> isAbstract [
	^ self == WDConvexCollisionShape
]

{ #category : 'accessing' }
WDConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ (otherShape detectAndComputeCollisionContactPointsAt: otherTransform withConvexShape: self at: transform separatingAxisHint: (separatingAxisHint ifNotNil: [separatingAxisHint negated])) collect: [ :each | each flipped ]
]

{ #category : 'accessing' }
WDConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ otherShape detectAndComputeCollisionContactPointsAt: otherTransform withConvexShape: self at: transform separatingAxisHint: separatingAxisHint
]

{ #category : 'accessing' }
WDConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	| firstSupportFunction secondSupportFunction
		gjkSimplex closestPointToOrigin totalMargin shapeDistance |
	firstSupportFunction := GeometricFunctions transformSupportFunction: self localSupportFunction with: transform.
	secondSupportFunction := GeometricFunctions transformSupportFunction: otherShape localSupportFunction with: otherTransform.
	gjkSimplex := GeometricFunctions gjkSimplexFor: firstSupportFunction with: secondSupportFunction separatingAxisHint: separatingAxisHint.
	
	closestPointToOrigin := gjkSimplex closestPointToOrigin.
	totalMargin := margin + otherShape margin.
	shapeDistance := closestPointToOrigin length.

	shapeDistance > totalMargin ifTrue: [ ^ #() ].	

	shapeDistance >= ShallowPenetrationThreshold ifTrue: [
		^ {WDContactPoint new
				normal: closestPointToOrigin normalized;
				requiredSeparation: totalMargin;
				firstPoint: gjkSimplex closestPointToOriginInFirst;
				secondPoint: gjkSimplex closestPointToOriginInSecond;
				computeLocalVersionWithFirstTransform: transform secondTransform: otherTransform;
				computeWorldContactPointAndDistances;
				yourself
		}
	] ifFalse: [
		| distanceAndNormal |
		distanceAndNormal := GeometricFunctions samplePenetrationContactForSupport: firstSupportFunction with: secondSupportFunction margin: totalMargin separatingAxisHint: separatingAxisHint.
		distanceAndNormal ifNil: [ ^ #() ].
		
		^ {WDContactPoint new
				normal: distanceAndNormal second;
				requiredSeparation: totalMargin;
				firstPoint: distanceAndNormal third;
				secondPoint: distanceAndNormal fourth;
				computeLocalVersionWithFirstTransform: transform secondTransform: otherTransform;
				computeWorldContactPointAndDistances;
				yourself
		}
	]
]

{ #category : 'accessing' }
WDConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withHeightfieldShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ otherShape detectAndComputeCollisionContactPointsAt: otherTransform withConvexShape: self at: transform separatingAxisHint: separatingAxisHint
]

{ #category : 'as yet unclassified' }
WDConvexCollisionShape >> localBoundaryCorners [
	^ localBoundingBox corners
]

{ #category : 'intersection testing' }
WDConvexCollisionShape >> localSupportFunction [
	^ [ :d | self localSupportInDirection: d ]
]

{ #category : 'intersection testing' }
WDConvexCollisionShape >> localSupportInDirection: aDirection [
	self subclassResponsibility
]

{ #category : 'intersection testing' }
WDConvexCollisionShape >> localSupportInDirectionWithMargin: aDirection [
	^ (self localSupportInDirection: aDirection) + margin
]

{ #category : 'accessing' }
WDConvexCollisionShape >> rayCast: ray [
	| gjkResult |
	gjkResult := GeometricFunctions gjkRayCast: ray support: [:d | self localSupportInDirectionWithMargin: d].
	gjkResult ifNil: [ ^ nil ].
	
	^ WDPShapeRayCastingResult new
		shape: self;
		distance: gjkResult first;
		normal: gjkResult second normalized;
		yourself
	
	
]

{ #category : 'accessing' }
WDConvexCollisionShape >> withTransform: shapeTransform intersectsBox: box withTransform: boxTransform [
	| mySupportFunction otherSupportFunction |
	mySupportFunction := GeometricFunctions transformSupportFunction: self localSupportFunction with: shapeTransform.
	otherSupportFunction := GeometricFunctions transformSupportFunction: box supportFunction with: boxTransform.
	^ (GeometricFunctions gjkDistanceFrom: mySupportFunction to: otherSupportFunction) <= margin
]

{ #category : 'accessing' }
WDConvexCollisionShape >> withTransform: shapeTransform intersectsSphere: sphere withTransform: sphereTransform [
	| mySupportFunction otherSupportFunction |
	mySupportFunction := GeometricFunctions transformSupportFunction: self localSupportFunction with: shapeTransform.
	otherSupportFunction := GeometricFunctions transformSupportFunction: sphere supportFunction with: sphereTransform.
	^ (GeometricFunctions gjkDistanceFrom: mySupportFunction to: otherSupportFunction) <= margin
]
