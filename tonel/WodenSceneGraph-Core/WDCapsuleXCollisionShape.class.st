"
I am a capsule collision shape which is aligned along the X axis.
"
Class {
	#name : 'WDCapsuleXCollisionShape',
	#superclass : 'WDAbstractCapsuleCollisionShape',
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'accessing' }
WDCapsuleXCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: halfHeight + radius y: radius z: radius)).
	
]

{ #category : 'adding' }
WDCapsuleXCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius + halfHeight y: radius z: radius);
			mesh) asSceneNode 
]

{ #category : 'intersection testing' }
WDCapsuleXCollisionShape >> localSupportInDirection: d [
	^ (Vector3 x: d y sign * halfHeight) + (d normalized * radius).
]
