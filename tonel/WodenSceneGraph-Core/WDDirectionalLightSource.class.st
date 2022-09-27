"
I am a directional light source.

I point towards the front direction, so that my orientation can be adjusted through my parent scene node transformation.
"
Class {
	#name : #WDDirectionalLightSource,
	#superclass : #WDLightSource,
	#instVars : [
		'shadowCastingRadius',
		'shadowSnappingQuanta'
	],
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #adding }
WDDirectionalLightSource >> addToRenderingScene: renderingScene withGlobalTransform: globalTransform [
	renderingScene addLight: (self asLightStateForRenderingScene: renderingScene withTransform: globalTransform)
]

{ #category : #converting }
WDDirectionalLightSource >> asLightStateForRenderingScene: renderingScene withTransform: renderingTransform [
	| result direction |
	direction := renderingTransform matrix thirdColumn.
	result := WDLightState new
		positionOrDirection: (Vector4 xyz: direction w: 0.0);
		intensity: intensity;
		yourself.
	castShadows ifTrue: [
		self setupShadowMapCascadeFor: result renderingScene: renderingScene withTransform: renderingTransform direction: direction
	].
		
	^ result
]

{ #category : #initialization }
WDDirectionalLightSource >> initialize [
	super initialize.
	shadowCastingRadius := 1000.0.
	shadowSnappingQuanta := 0.1.
]

{ #category : #shadows }
WDDirectionalLightSource >> setupShadowMapCameraStateForRenderingScene: renderingScene frustum: sliceFrustum withTransform: renderingTransform direction: direction [
	| shadowCastingVolume shadowCastingVolumeWorldBoundingBox shadowTransform localShadowCastingVolume |
	
	"Compute the shadow casting volume."
	shadowCastingVolume := OrderedCollection new.
	sliceFrustum corners do: [ :eachCorner |
		shadowCastingVolume
			add: eachCorner;
			add: eachCorner + (direction * shadowCastingRadius)
	].

	"Create a transform with the same rotation and the rounded center"
	shadowCastingVolumeWorldBoundingBox := AABox encompassing: shadowCastingVolume.
	shadowTransform := renderingTransform copy
		translation: (self snapShadowVolumeCenter: shadowCastingVolumeWorldBoundingBox center);
		yourself.
		
	"Compute a local version of the shadow casting volume."
	localShadowCastingVolume := AABox empty.
	shadowCastingVolume do: [ :each |
		localShadowCastingVolume insertPoint: (shadowTransform inverseTransformPosition: each)
	].
	
	"Snap the local shadow casting volume."
	localShadowCastingVolume := self snapShadowVolumeBox: localShadowCastingVolume.
	
	^ WDCameraState new
		nearDistance: localShadowCastingVolume min z;
		farDistance: localShadowCastingVolume max z;
		projectionMatrix: (Matrix4x4 reverseDepthOrthoLeft: localShadowCastingVolume min x right: localShadowCastingVolume max x
			bottom: localShadowCastingVolume min y top: localShadowCastingVolume max y
			near: localShadowCastingVolume max z negated far: localShadowCastingVolume min z negated);
		frustum: (Frustum new makeOrthoLeft: localShadowCastingVolume min x right: localShadowCastingVolume max x
			bottom: localShadowCastingVolume min y top: localShadowCastingVolume max y
			near: localShadowCastingVolume max z negated far: localShadowCastingVolume min z negated);
		hasReverseDepth: true;
		transformation: shadowTransform;
		yourself
]

{ #category : #shadows }
WDDirectionalLightSource >> setupShadowMapCascadeFor: lightState renderingScene: renderingScene withTransform: renderingTransform direction: direction [
	| cameraState frustum nearDistance farDistance cascadeSplitDistributionLambda numSlices splitDistributionDistances splitDistributionLambdas |
	cameraState := renderingScene cameraState.
	frustum := cameraState worldFrustum.

	nearDistance := cameraState nearDistance.
	farDistance := cameraState farDistance.
	cascadeSplitDistributionLambda := cameraState cascadeSplitDistributionLambda.

	"Cascade shadow map split distribution scheme from GPU Gems 3, Chapter 10: Parallel-Split Shadow Maps on Programmable GPUs [https://developer.nvidia.com/gpugems/gpugems3/part-ii-light-and-shadows/chapter-10-parallel-split-shadow-maps-programmable-gpus]"
	numSlices := 4. 
	splitDistributionDistances := (0 to: 4) collect: [ :i | 
		| uniformSlice exponentialSlice |
		uniformSlice := (farDistance - nearDistance) / numSlices * i + nearDistance.
		exponentialSlice := nearDistance * (farDistance / nearDistance raisedTo: i / numSlices).
		uniformSlice interpolateTo: exponentialSlice at: cascadeSplitDistributionLambda
	].

	splitDistributionLambdas := splitDistributionDistances collect: [ :distance |
		(distance - nearDistance) / (farDistance  - nearDistance) min: 1.0 max: 0.0
	].

	lightState
		castShadows: true;
		shadowMapCascadeDistanceWorldTransform: cameraState inverseTransformationMatrix thirdRow negated;
		shadowMapCascadeOffsets: (Vector4 x: splitDistributionDistances second y: splitDistributionDistances third z: splitDistributionDistances fourth w: splitDistributionDistances fifth);
		shadowMappingCameraStates: ((1 to: numSlices) collect: [ :sliceIndex |
		| sliceFrustum |
		sliceFrustum := frustum splitAtNearLambda: (splitDistributionLambdas at: sliceIndex) farLambda: (splitDistributionLambdas at: sliceIndex + 1).
		self setupShadowMapCameraStateForRenderingScene: renderingScene frustum: sliceFrustum  withTransform: renderingTransform direction: direction
	])

]

{ #category : #accessing }
WDDirectionalLightSource >> shadowCastingRadius [

	^ shadowCastingRadius
]

{ #category : #accessing }
WDDirectionalLightSource >> shadowCastingRadius: anObject [

	shadowCastingRadius := anObject
]

{ #category : #initialization }
WDDirectionalLightSource >> snapShadowVolumeBox: box [
	^ AABox min: (self snapShadowVolumeMin: box min) max: (self snapShadowVolumeMax: box max)
]

{ #category : #initialization }
WDDirectionalLightSource >> snapShadowVolumeCenter: point [
	^ (point / shadowSnappingQuanta + 0.5) floor * shadowSnappingQuanta
]

{ #category : #initialization }
WDDirectionalLightSource >> snapShadowVolumeMax: point [
	^ (point / shadowSnappingQuanta) ceiling * shadowSnappingQuanta
]

{ #category : #initialization }
WDDirectionalLightSource >> snapShadowVolumeMin: point [
	^ (point / shadowSnappingQuanta) floor * shadowSnappingQuanta
]
