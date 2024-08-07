"
I am a specification for a camera.
"
Class {
	#name : 'WDCamera',
	#superclass : 'Object',
	#instVars : [
		'nearDistance',
		'farDistance',
		'fovY',
		'focalDistance',
		'isPerspective',
		'hasReverseDepth',
		'currentTime',
		'exposure',
		'toneMappingOperator',
		'viewMode',
		'bloomThreshold',
		'bloomStrength',
		'cascadeSplitDistributionLambda',
		'headFloorTransform',
		'fogColor',
		'fogStartDistance',
		'fogEndDistance',
		'fogDensity',
		'fogMode'
	],
	#category : 'WodenSceneGraph-Core-Camera',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Camera'
}

{ #category : 'accessing' }
WDCamera >> asCameraFovY [
	^ fovY
]

{ #category : 'converting' }
WDCamera >> asCameraStateWithAspectRatio: aspectRatio [
	^ WDCameraState new
		nearDistance: nearDistance;
		farDistance: farDistance;
		isPerspective: isPerspective;
		projectionMatrix: (self projectionMatrixWithAspect: aspectRatio);
		frustum: (self frustumWithAspect: aspectRatio);
		currentTime: currentTime;
		exposure: exposure;
		bloomThreshold: bloomThreshold;
		bloomStrength: bloomStrength;
		toneMappingOperator: toneMappingOperator;
		viewMode: viewMode;
		hasReverseDepth: hasReverseDepth;
		cascadeSplitDistributionLambda: cascadeSplitDistributionLambda;
		fogColor: fogColor;
		fogDistancesOrParameters: self fogDistancesOrParameters;
		fogMode: fogMode asModeIndex;
		yourself
]

{ #category : 'converting' }
WDCamera >> asCameraStateWithFrustumTangents: frustumTangents eyeTransform: eyeTransform [
	^ WDCameraState new
		nearDistance: nearDistance;
		farDistance: farDistance;
		isPerspective: isPerspective;
		projectionMatrix: (self projectionMatrixWithFrustumTangents: frustumTangents);
		frustum: (self frustumWithTangents: frustumTangents);
		currentTime: currentTime;
		exposure: exposure;
		bloomThreshold: bloomThreshold;
		bloomStrength: bloomStrength;
		toneMappingOperator: toneMappingOperator;
		viewMode: viewMode;
		hasReverseDepth: hasReverseDepth;
		transformation: eyeTransform;
		cascadeSplitDistributionLambda: cascadeSplitDistributionLambda;
		fogColor: fogColor;
		fogDistancesOrParameters: self fogDistancesOrParameters;
		fogMode: fogMode asModeIndex;
		yourself
]

{ #category : 'converting' }
WDCamera >> asSceneElement [
	^ self asSceneNode
]

{ #category : 'converting' }
WDCamera >> asSceneNode [
	^ WDSceneNode new
		cameras: { self };
		yourself
]

{ #category : 'accessing' }
WDCamera >> bloomStrength [

	^ bloomStrength
]

{ #category : 'accessing' }
WDCamera >> bloomStrength: anObject [

	bloomStrength := anObject
]

{ #category : 'accessing' }
WDCamera >> bloomThreshold [

	^ bloomThreshold
]

{ #category : 'accessing' }
WDCamera >> bloomThreshold: anObject [

	bloomThreshold := anObject
]

{ #category : 'accessing' }
WDCamera >> currentTime [

	^ currentTime
]

{ #category : 'accessing' }
WDCamera >> currentTime: anObject [

	currentTime := anObject
]

{ #category : 'accessing' }
WDCamera >> exposure [

	^ exposure
]

{ #category : 'accessing' }
WDCamera >> exposure: anObject [

	exposure := anObject
]

{ #category : 'accessing' }
WDCamera >> farDistance [

	^ farDistance
]

{ #category : 'accessing' }
WDCamera >> farDistance: anObject [

	farDistance := anObject
]

{ #category : 'accessing' }
WDCamera >> focalDistance [

	^ focalDistance
]

{ #category : 'accessing' }
WDCamera >> focalDistance: anObject [

	focalDistance := anObject
]

{ #category : 'accessing' }
WDCamera >> fogColor [

	^ fogColor
]

{ #category : 'accessing' }
WDCamera >> fogColor: aFogColor [

	fogColor := aFogColor asVector4
]

{ #category : 'accessing' }
WDCamera >> fogDensity [

	^ fogDensity
]

{ #category : 'accessing' }
WDCamera >> fogDensity: anObject [

	fogDensity := anObject
]

{ #category : 'accessing' }
WDCamera >> fogDistancesOrParameters [
	^ fogMode usesDensity
		ifTrue:[ Vector2 x: fogDensity ]
		ifFalse:[ Vector2 x: fogStartDistance y: fogEndDistance ]
]

{ #category : 'accessing' }
WDCamera >> fogEndDistance [

	^ fogEndDistance
]

{ #category : 'accessing' }
WDCamera >> fogEndDistance: anObject [

	fogEndDistance := anObject
]

{ #category : 'accessing' }
WDCamera >> fogMode [
	^ fogMode
]

{ #category : 'accessing' }
WDCamera >> fogMode: aFogMode [
	fogMode := aFogMode asFogMode
]

{ #category : 'accessing' }
WDCamera >> fogStartDistance [

	^ fogStartDistance
]

{ #category : 'accessing' }
WDCamera >> fogStartDistance: anObject [

	fogStartDistance := anObject
]

{ #category : 'accessing' }
WDCamera >> fovY [

	^ fovY
]

{ #category : 'accessing' }
WDCamera >> fovY: anObject [

	fovY := anObject
]

{ #category : 'converting' }
WDCamera >> frustumWithAspect: aspectRatio [
	^ isPerspective ifTrue: [ 
		Frustum new makePerspectiveFovY: fovY aspect: aspectRatio near: nearDistance far: farDistance
	] ifFalse: [
		| hh hw |
		hh := (fovY / 2 ) degreesToRadians tan * focalDistance.
		hw := hh * aspectRatio.
		^ Frustum new makeOrthoLeft: hw negated right: hw bottom: hh negated top: hh near: nearDistance far: farDistance	
	]
]

{ #category : 'converting' }
WDCamera >> frustumWithTangents: tangents [
	^ Frustum new makeWithTangents: tangents near: nearDistance far: farDistance
]

{ #category : 'accessing' }
WDCamera >> hasReverseDepth [

	^ hasReverseDepth
]

{ #category : 'accessing' }
WDCamera >> hasReverseDepth: anObject [

	hasReverseDepth := anObject
]

{ #category : 'accessing' }
WDCamera >> headFloorTransform [

	^ headFloorTransform
]

{ #category : 'accessing' }
WDCamera >> headFloorTransform: anObject [

	headFloorTransform := anObject
]

{ #category : 'initialization' }
WDCamera >> initialize [
	super initialize.
	nearDistance := 0.01.
	farDistance := 1000.0.
	fovY := 60.0.
	focalDistance := 10.0.
	isPerspective := true.
	hasReverseDepth := true.
	currentTime := 0.0.
	exposure := 1.0.
	bloomThreshold := 1.0.
	bloomStrength := 0.1.
	cascadeSplitDistributionLambda := 0.99.
	headFloorTransform := ReversibleAffineTransform3D identity.
	fogColor := Vector4 zeros.
	fogStartDistance := 0.0.
	fogEndDistance := 1.0.
	fogDensity := 1.0.
	self fogMode: WDFogNoneMode.
	self toneMappingOperator: WDLinearToneMappingOperator.
	self viewMode: WDFullShadedViewMode.
]

{ #category : 'accessing' }
WDCamera >> isPerspective [

	^ isPerspective
]

{ #category : 'accessing' }
WDCamera >> isPerspective: anObject [

	isPerspective := anObject
]

{ #category : 'accessing' }
WDCamera >> nearDistance [

	^ nearDistance
]

{ #category : 'accessing' }
WDCamera >> nearDistance: anObject [

	nearDistance := anObject
]

{ #category : 'converting' }
WDCamera >> projectionMatrixWithAspect: aspectRatio [
	^ isPerspective ifTrue: [ 
		hasReverseDepth
			ifTrue: [ Matrix4x4 reverseDepthPerspectiveFovY: fovY aspect: aspectRatio near: nearDistance far: farDistance ]
			ifFalse: [ Matrix4x4 perspectiveFovY: fovY aspect: aspectRatio near: nearDistance far: farDistance ]
	] ifFalse: [
		| hh hw |
		hh := (fovY / 2 ) degreesToRadians tan * focalDistance.
		hw := hh * aspectRatio.
		^  hasReverseDepth
				ifTrue: [ Matrix4x4 reverseDepthOrthoLeft: hw negated right: hw bottom: hh negated top: hh near: nearDistance far: farDistance ]
				ifFalse: [ Matrix4x4 orthoLeft: hw negated right: hw bottom: hh negated top: hh near: nearDistance far: farDistance ]
			
	]
]

{ #category : 'converting' }
WDCamera >> projectionMatrixWithFrustumTangents: frustumTangents [
	^ hasReverseDepth
		ifTrue: [ Matrix4x4 reverseDepthFrustumTangents: frustumTangents near: nearDistance far: farDistance ]
		ifFalse: [ Matrix4x4 frustumTangents: frustumTangents near: nearDistance far: farDistance ]
]

{ #category : 'accessing' }
WDCamera >> toneMappingOperator [

	^ toneMappingOperator
]

{ #category : 'accessing' }
WDCamera >> toneMappingOperator: aToneMappingOperator [
	toneMappingOperator := aToneMappingOperator asToneMappingOperator
]

{ #category : 'accessing' }
WDCamera >> viewMode [
	^ viewMode
]

{ #category : 'accessing' }
WDCamera >> viewMode: aViewMode [
	viewMode := aViewMode asViewMode
]
