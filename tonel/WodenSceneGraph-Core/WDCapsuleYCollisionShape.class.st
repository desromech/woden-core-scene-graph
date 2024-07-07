"
I am a capsule collision shape which is aligned along the Y axis.
"
Class {
	#name : 'WDCapsuleYCollisionShape',
	#superclass : 'WDAbstractCapsuleCollisionShape',
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'construction' }
WDCapsuleYCollisionShape class >> height: height radius: radius [
	^ self new height: height; radius: radius; yourself
]

{ #category : 'accessing' }
WDCapsuleYCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: radius y: halfHeight + radius z: radius)).
	
]

{ #category : 'adding' }
WDCapsuleYCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: halfHeight + radius z: radius);
			mesh) asSceneNode 
]

{ #category : 'intersection testing' }
WDCapsuleYCollisionShape >> localSupportInDirection: d [
	^ (Vector3 y: d y sign * halfHeight) + (d normalized * radius).
]
