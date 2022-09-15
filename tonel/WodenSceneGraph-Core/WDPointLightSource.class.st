"
I am a punctual light source.

I have a specific influence radius that constraints the locations that are affected by me.
"
Class {
	#name : #WDPointLightSource,
	#superclass : #WDLightSource,
	#instVars : [
		'influenceRadius'
	],
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #adding }
WDPointLightSource >> addToRenderingScene: renderingScene withGlobalTransform: globalTransform [
	(renderingScene shouldRenderWorldSphereWithCenter: globalTransform translation radius: influenceRadius) ifTrue: [
		renderingScene addLight: (self asLightStateWithTransform: globalTransform)
	].
]

{ #category : #converting }
WDPointLightSource >> asLightStateWithTransform: renderingTransform [
	^ WDLightState new
		positionOrDirection: (Vector4 xyz: renderingTransform translation w: 1.0);
		influenceRadius: influenceRadius;
		intensity: intensity;
		castShadows: castShadows;
		shadowMappingCameraStates: (self shadowMapCameraStatesWithTransform: renderingTransform);
		yourself.
]

{ #category : #accessing }
WDPointLightSource >> boundingBox [
	^ AABox halfExtent: influenceRadius asVector3
]

{ #category : #accessing }
WDPointLightSource >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDPointLightSource >> influenceRadius: anObject [

	influenceRadius := anObject
]

{ #category : #initialization }
WDPointLightSource >> initialize [
	super initialize.
	influenceRadius := 1.0.
]

{ #category : #accessing }
WDPointLightSource >> shadowMapCameraStatesWithTransform: worldRenderingTransform [
	| nearDistance farDistance aspect fovy baseState |
	castShadows ifFalse: [ ^ #() ].
	
	nearDistance := 0.01.
	farDistance := influenceRadius.
	aspect := 1.0.
	fovy := 90.0.
	baseState := WDCameraState new
		nearDistance: nearDistance;
		farDistance: influenceRadius;
		projectionMatrix: (Matrix4x4 reverseDepthPerspectiveFovY: fovy aspect: aspect near: nearDistance far: farDistance);
		frustum: (Frustum new makePerspectiveFovY: fovy aspect: aspect near: nearDistance far: farDistance);
		hasReverseDepth: true;
		yourself.
		
	^ Matrix3x3 cubeMapFaceRotations collect: [ :faceRotationMatrix |
		baseState copy
			transformation: (ReversibleAffineTransform3D orthonormal: faceRotationMatrix translation: worldRenderingTransform translation);
			yourself
	]
]
