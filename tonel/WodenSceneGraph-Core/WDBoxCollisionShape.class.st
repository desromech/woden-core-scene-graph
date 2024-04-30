"
I am an axis-aligned (in local space) box collision shape.
"
Class {
	#name : #WDBoxCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'halfExtent'
	],
	#category : #'WodenSceneGraph-Core-Collision'
}

{ #category : #accessing }
WDBoxCollisionShape class >> halfExtent: halfExtent [
	^ self new halfExtent: halfExtent; yourself
]

{ #category : #'mass distribution' }
WDBoxCollisionShape >> computeInertiaTensorWithMass: mass [
	| extent extentSquared mo12 |
	extent := halfExtent * 2.
	extentSquared := extent * extent.
	mo12 := mass / 12.
	
	^ Matrix3x3 new
		m11: mo12 * (extentSquared y + extentSquared z);
		m22: mo12 * (extentSquared x + extentSquared z);
		m33: mo12 * (extentSquared x + extentSquared y);
		yourself
]

{ #category : #adding }
WDBoxCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: halfExtent;
			mesh) asSceneNode
]

{ #category : #accessing }
WDBoxCollisionShape >> halfExtent [

	^ halfExtent
]

{ #category : #accessing }
WDBoxCollisionShape >> halfExtent: newHalfExtent [
	halfExtent := newHalfExtent asVector3.
	self localBoundingBox: (AABox halfExtent: halfExtent).
]

{ #category : #initialization }
WDBoxCollisionShape >> initialize [
	super initialize.
	halfExtent := Vector3 ones
]

{ #category : #'intersection testing' }
WDBoxCollisionShape >> localSupportInDirection: aDirection [
	^ halfExtent * aDirection nonZeroSign
]
