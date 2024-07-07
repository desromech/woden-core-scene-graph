"
I am a null collision shape.
"
Class {
	#name : 'WDNullCollisionShape',
	#superclass : 'WDCollisionShape',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'WodenSceneGraph-Core-Collision',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Collision'
}

{ #category : 'instance creation' }
WDNullCollisionShape class >> new [
	self error: 'WDNullCollisionShape is a stateless singleton'
]

{ #category : 'accessing' }
WDNullCollisionShape class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'adding' }
WDNullCollisionShape >> constructVisualizationSceneNode [
	^ WDSceneNode new
]

{ #category : 'collision detection' }
WDNullCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'collision detection' }
WDNullCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : 'testing' }
WDNullCollisionShape >> isEmptyShape [
	^ true
]

{ #category : 'intersection testing' }
WDNullCollisionShape >> localSupportInDirection: aDirection [
	^ Vector3 zeros
]

{ #category : 'testing' }
WDNullCollisionShape >> rayCast: ray [
	^ nil
]

{ #category : 'transforming' }
WDNullCollisionShape >> transformedWith: aTransform [
	^ self
]
