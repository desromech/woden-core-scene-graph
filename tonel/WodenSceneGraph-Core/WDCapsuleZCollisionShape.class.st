"
I am a capsule collision shape which is aligned along the Z axis.
"
Class {
	#name : #WDCapsuleZCollisionShape,
	#superclass : #WDAbstractCapsuleCollisionShape,
	#category : #'WodenSceneGraph-Core-Collision'
}

{ #category : #accessing }
WDCapsuleZCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: radius y: radius z: halfHeight + radius)).
	
]

{ #category : #adding }
WDCapsuleZCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: radius z: halfHeight);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDCapsuleZCollisionShape >> localSupportInDirection: d [
	^ (Vector3 z: d y sign * halfHeight) + (d normalized * radius).
]
