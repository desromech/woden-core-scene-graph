"
I am a collision shape that uses a heightfield.
"
Class {
	#name : 'WDHeightfieldCollisionShape',
	#superclass : 'WDCollisionShape',
	#instVars : [
		'width',
		'depth',
		'data',
		'scale'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'adding' }
WDHeightfieldCollisionShape >> constructVisualizationSceneNode [
	^ WDSceneNode new
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> data [

	^ data
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> data: anObject [

	data := anObject
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> depth [

	^ depth
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> depth: anObject [

	depth := anObject
]

{ #category : 'collision detection' }
WDHeightfieldCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ otherShape detectAndComputeCollisionContactPointsAt: otherTransform withHeightfieldShape: self at: transform separatingAxisHint: separatingAxisHint
]

{ #category : 'collision detection' }
WDHeightfieldCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ self detectAndComputeCollisionContactPointsAt: transform withShapeBoundaryCorners: otherShape at: otherTransform separatingAxisHint: separatingAxisHint
]

{ #category : 'collision detection' }
WDHeightfieldCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ self detectAndComputeCollisionContactPointsAt: transform withShapeBoundaryCorners: otherShape at: otherTransform separatingAxisHint: separatingAxisHint
]

{ #category : 'collision detection' }
WDHeightfieldCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withHeightfieldShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'collision detection' }
WDHeightfieldCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withShapeBoundaryCorners: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	| worstPenetrationDistance worstPenetrationPoint |
	worstPenetrationDistance := Float negativeInfinity.
	worstPenetrationPoint := nil.
	
	otherShape localBoundaryCorners do: [ :eachCorner |
		| eachWorldCorner eachLocalCorner |
		eachWorldCorner := otherTransform transformPosition: eachCorner.
		eachLocalCorner := (transform inverseTransformPosition: eachWorldCorner) / scale.
		(0 < eachLocalCorner x and: [eachLocalCorner x < 1 and: [
		0 < eachLocalCorner z and: [eachLocalCorner z < 1]]]) ifTrue: [
			| heightSample samplePenetrationDistance |
			heightSample := self sampleInterpolatedHeightAtX: eachLocalCorner x z: eachLocalCorner z.
			samplePenetrationDistance := heightSample - eachLocalCorner y.
			samplePenetrationDistance > worstPenetrationDistance ifTrue: [ 
				worstPenetrationDistance := samplePenetrationDistance.
				worstPenetrationPoint := eachWorldCorner
			].
		]
	].

	(worstPenetrationDistance >= 0 and: [ worstPenetrationPoint isNotNil ]) ifTrue: [
		^ {WDContactPoint new
				normal: (Vector3 y: -1);
				requiredSeparation: worstPenetrationDistance;
				firstPoint: worstPenetrationPoint;
				secondPoint: worstPenetrationPoint;
				computeLocalVersionWithFirstTransform: transform secondTransform: otherTransform;
				computeWorldContactPointAndDistances;
				yourself
		}
	].
	^ #()
]

{ #category : 'testing' }
WDHeightfieldCollisionShape >> rayCast: ray [
	| boxHit entryPoint exitPoint previousPointHeight previousHeightSample |
	boxHit := self localBoundingBox intersectionsWithRay: ray.
	boxHit ifNil: [ ^ nil ].

	entryPoint := ray pointAtDistance: boxHit first.
	exitPoint := ray pointAtDistance: boxHit second.

	previousPointHeight := entryPoint y.
	previousHeightSample := self sampleHeightAtX: entryPoint x z: entryPoint z.
	0 to: 1 by: (1 / (width max: depth)) do: [ :alpha |
		| testPoint heightSample testPointHeight minHeightSample maxHeightSample minPointHeight maxPointHeight |
		testPoint := entryPoint interpolateTo: exitPoint at: alpha.
		heightSample := self sampleHeightAtX: testPoint x z: testPoint z.
		testPointHeight := testPoint y.
		
		minHeightSample := previousHeightSample min: heightSample.
		maxHeightSample := previousHeightSample max: heightSample.

		minPointHeight := previousPointHeight min: testPointHeight.
		maxPointHeight := previousPointHeight max: testPointHeight.
		
		(maxPointHeight < minHeightSample or: [ maxHeightSample < minPointHeight ]) ifFalse: [
			| hitPoint |
			hitPoint := boxHit first interpolateTo: boxHit second at: alpha.
			
			^ WDShapeRayCastingResult new
				shape: self;
				distance: (ray distanceForPoint: hitPoint);
				normal: (Vector3 y: 1);
				yourself
		].
		
		previousPointHeight := testPointHeight.
		previousHeightSample := heightSample.
	].
	
	^ nil
]

{ #category : 'as yet unclassified' }
WDHeightfieldCollisionShape >> sampleHeightAtX: x z: z [
	| sampleColumn sampleRow |
	sampleColumn := (x * width) floor min: width - 1 max: 0.
	sampleRow := (z * depth) floor min: depth - 1 max: 0.
	^ data at: sampleRow*width + sampleColumn + 1
]

{ #category : 'as yet unclassified' }
WDHeightfieldCollisionShape >> sampleInterpolatedHeightAtX: x z: z [
	| sampleColumn sampleRow u v uf vf sampleColumnNext sampleRowNext tl fru frv tr bl br t b |
	u := x * width.
	v := z * depth.
	
	uf := u floor.
	fru := u - uf.
	vf := v floor.
	frv := v - vf.
	sampleColumn := uf min: width - 1 max: 0.
	sampleRow := vf min: depth - 1 max: 0.
	sampleColumnNext := uf + 1 min: width - 1 max: 0.
	sampleRowNext := vf + 1 min: depth - 1 max: 0.

	tl := data at: sampleRow*width + sampleColumn + 1.
	tr := data at: sampleRow*width + sampleColumnNext + 1.	
	bl := data at: sampleRowNext*width + sampleColumn + 1.
	br := data at: sampleRowNext*width + sampleColumnNext + 1.
	t := tl interpolateTo: tr at: fru.
	b := bl interpolateTo: br at: fru.
	^ t interpolateTo: b at: frv
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> scale [

	^ scale
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> scale: anObject [

	scale := anObject
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> width [

	^ width
]

{ #category : 'accessing' }
WDHeightfieldCollisionShape >> width: anObject [

	width := anObject
]
