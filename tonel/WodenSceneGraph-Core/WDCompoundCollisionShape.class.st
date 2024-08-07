Class {
	#name : 'WDCompoundCollisionShape',
	#superclass : 'WDCollisionShape',
	#instVars : [
		'components',
		'localBoundaryCorners'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'adding' }
WDCompoundCollisionShape >> addComponent: aShapeComponent [
	components add: aShapeComponent.
	components size = 1 ifTrue: [ 
		self localBoundingBox: aShapeComponent boundingBox
	] ifFalse: [ 
		self localBoundingBox: (self localBoundingBox insertBox: aShapeComponent boundingBox )
	].
	localBoundaryCorners := nil.
]

{ #category : 'adding' }
WDCompoundCollisionShape >> addShape: aShape [
	self addShape: aShape withTransform: ReversibleAffineTransform3D identity
]

{ #category : 'adding' }
WDCompoundCollisionShape >> addShape: aShape withTransform: aTransform [
	| reversibleAffineTransform |
	reversibleAffineTransform := aTransform asReversibleAffineTransform.
	
	aShape isCompoundCollisionShape ifTrue: [
		aShape components do: [ :eachComponent |
			self addComponent: (WDCompoundCollisionShapeComponent new
				shape: eachComponent shape;
				transform: (reversibleAffineTransform transformTransform: eachComponent transform);
				yourself)
		]
	] ifFalse: [ 
		self addComponent: (WDCompoundCollisionShapeComponent new
			shape: aShape;
			transform: reversibleAffineTransform;
			yourself).
	].

]

{ #category : 'accessing' }
WDCompoundCollisionShape >> components [

	^ components
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> componentsIntersectingBox: boundingBoxToTest do: aBlock [
	components do: [ :each |
		(each boundingBox hasIntersectionWithBox: boundingBoxToTest) ifTrue: [ 
			aBlock value: each
		]
	].
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> componentsIntersectingRay: rayToTest do: aBlock [
	components do: [ :each |
		(each boundingBox hasIntersectionWithRay: rayToTest) ifTrue: [ 
			aBlock value: each
		]
	].
]

{ #category : 'adding' }
WDCompoundCollisionShape >> constructVisualizationSceneNode [
	| compoundNode |
	compoundNode := WDSceneNode new.
	components do: [ :eachComponent |
		compoundNode add: (eachComponent shape constructVisualizationSceneNode
			transform: eachComponent transform;
			yourself)
	].
	
	^ compoundNode
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ otherShape detectAndComputeCollisionContactPointsAt: otherTransform withCompoundShape: self at: transform separatingAxisHint: separatingAxisHint
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	| results myReversibleTransform otherLocalBoundingBox |
	results := OrderedCollection new.
	myReversibleTransform := transform asReversibleAffineTransform.
	otherLocalBoundingBox := (otherShape localBoundingBoxWithMargin transformedWith: otherTransform) inverseTransformedWith: myReversibleTransform.
	
	self componentsIntersectingBox: otherLocalBoundingBox do: [ :eachComponent |
		| componentWorldTransform |
		componentWorldTransform := myReversibleTransform transformTransform: eachComponent transform.
		results addAll: (eachComponent shape detectAndComputeCollisionContactPointsAt: componentWorldTransform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint)
	].

	^ results
]

{ #category : 'initialization' }
WDCompoundCollisionShape >> initialize [
	super initialize.
	components := OrderedCollection new.
]

{ #category : 'testing' }
WDCompoundCollisionShape >> isCompoundCollisionShape [
	^ true

]

{ #category : 'as yet unclassified' }
WDCompoundCollisionShape >> localBoundaryCorners [
	^ localBoundaryCorners ifNil: [
		| corners |
		corners := OrderedCollection new.
		self components do: [ :eachComponent |
			eachComponent shape localBoundaryCorners do: [ :eachComponentCorner |
				corners add: (eachComponent shape transform transformPosition: eachComponentCorner)
			]
		].
	
		localBoundaryCorners := corners asArray
	]
]

{ #category : 'collision detection' }
WDCompoundCollisionShape >> rayCast: ray [
	| result |
	result := nil.
	self componentsIntersectingRay: ray do: [:eachComponent |
		| shapeRay |
		shapeRay := ray inverseTransformedWith: eachComponent transform.
		(eachComponent shape rayCast: shapeRay) ifNotNil: [ :shapeRayResult |
			(result isNil or: [shapeRayResult distance < result distance]) ifTrue: [
				result := shapeRayResult
			].
		]
	].

	^ result
]

{ #category : 'transforming' }
WDCompoundCollisionShape >> transformedWith: aTransform [
	| reversibleAffineTransform result |
	reversibleAffineTransform := aTransform asReversibleAffineTransform3D.
	result := self class new.
	components do: [ :eachComponent |
		result addShape: eachComponent shape withTransform: (reversibleAffineTransform transformTransform: eachComponent transform)
	].
	^ result
]
