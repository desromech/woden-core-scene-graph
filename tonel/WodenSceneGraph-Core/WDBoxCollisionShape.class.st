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
	^ (Matrix3x3 inertiaTensorForBoxWithHalfExtent: halfExtent) * mass
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
