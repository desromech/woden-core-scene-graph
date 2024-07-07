"
I am a null collision shape.
"
Class {
	#name : 'WDPNullCollisionShape',
	#superclass : 'WDCollisionShape',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'instance creation' }
WDPNullCollisionShape class >> new [
	self error: 'WDNullCollisionShape is a stateless singleton'
]

{ #category : 'accessing' }
WDPNullCollisionShape class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'adding' }
WDPNullCollisionShape >> constructVisualizationSceneNode [
	^ WDSceneNode new
]

{ #category : 'collision detection' }
WDPNullCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'collision detection' }
WDPNullCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'testing' }
WDPNullCollisionShape >> isEmptyShape [
	^ true
]

{ #category : 'intersection testing' }
WDPNullCollisionShape >> localSupportInDirection: aDirection [
	^ Vector3 zeros
]

{ #category : 'testing' }
WDPNullCollisionShape >> rayCast: ray [
	^ nil
]

{ #category : 'transforming' }
WDPNullCollisionShape >> transformedWith: aTransform [
	^ self
]
