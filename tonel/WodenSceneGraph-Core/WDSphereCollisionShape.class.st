"
I am a sphere collision shape.
"
Class {
	#name : #WDSphereCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'radius'
	],
	#category : #'WodenSceneGraph-Core-Collision'
}

{ #category : #accessing }
WDSphereCollisionShape class >> radius: radius [
	^ self new radius: radius; yourself
]

{ #category : #'mass distribution' }
WDSphereCollisionShape >> computeInertiaTensorWithMass: mass [
	| i |
	i := mass * radius * radius * 2 * 5. 
	
	^ Matrix3x3 scale: i
]

{ #category : #adding }
WDSphereCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addUVSphereWithRadius: radius segments: 16 slices: 16;
			mesh) asSceneNode 
]

{ #category : #initialization }
WDSphereCollisionShape >> initialize [
	super initialize.
	radius := 1.0.
	
]

{ #category : #'intersection testing' }
WDSphereCollisionShape >> localSupportInDirection: aDirection [
	^ aDirection normalized * radius
]

{ #category : #accessing }
WDSphereCollisionShape >> radius [

	^ radius
]

{ #category : #accessing }
WDSphereCollisionShape >> radius: aNumber [
	radius := aNumber.
	self localBoundingBox: (AABox halfExtent: radius)
]
