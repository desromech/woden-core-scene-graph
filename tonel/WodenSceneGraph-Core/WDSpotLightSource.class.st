"
I am a punctual light source that directs its light into a cone.

"
Class {
	#name : 'WDSpotLightSource',
	#superclass : 'WDPointLightSource',
	#instVars : [
		'innerCutoff',
		'outerCutoff'
	],
	#category : 'WodenSceneGraph-Core-Lighting',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Lighting'
}

{ #category : 'converting' }
WDSpotLightSource >> asLightStateForRenderingScene: renderingScene withTransform: renderingTransform [
	^ (super asLightStateForRenderingScene: renderingScene withTransform: renderingTransform)
		spotDirection: renderingTransform matrix thirdColumn normalized;
		innerSpotCosCutoff: innerCutoff degreeCos;
		outerSpotCosCutoff: outerCutoff degreeCos;
		castShadows: castShadows;
		shadowMapDepthBiasConstant: shadowMapDepthBiasConstant;
		shadowMapDepthBiasSlope: shadowMapDepthBiasSlope;
		shadowMapNormalBiasFactor: shadowMapNormalBiasFactor;
		shadowMappingCameraStates: (self shadowMapCameraStatesWithTransform: renderingTransform);
		yourself.
]

{ #category : 'as yet unclassified' }
WDSpotLightSource >> exportToGltfWith: builder [
	^ (super exportToGltfWith: builder)
		type: 'spot';
		range: influenceRadius;
		innerConeAngle: innerCutoff degreesToRadians;
		outerConeAngle: outerCutoff degreesToRadians;
		yourself
]

{ #category : 'initialization' }
WDSpotLightSource >> initialize [
	super initialize.
	innerCutoff := 45.0.
	outerCutoff := 60.0.
]

{ #category : 'accessing' }
WDSpotLightSource >> innerCutoff [

	^ innerCutoff
]

{ #category : 'accessing' }
WDSpotLightSource >> innerCutoff: anObject [

	innerCutoff := anObject
]

{ #category : 'accessing' }
WDSpotLightSource >> outerCutoff [

	^ outerCutoff
]

{ #category : 'accessing' }
WDSpotLightSource >> outerCutoff: anObject [

	outerCutoff := anObject
]

{ #category : 'accessing' }
WDSpotLightSource >> shadowMapCameraStatesWithTransform: worldRenderingTransform [
	| nearDistance farDistance aspect fovy |
	castShadows ifFalse: [ ^ #() ].
	
	nearDistance := 0.01.
	farDistance := influenceRadius.
	aspect := 1.0.
	fovy := outerCutoff*2.
	
	^ {WDCameraState new
		nearDistance: nearDistance;
		farDistance: influenceRadius;
		isPerspective: true;
		projectionMatrix: (Matrix4x4 reverseDepthPerspectiveFovY: fovy aspect: aspect near: nearDistance far: farDistance);
		frustum: (Frustum new makePerspectiveFovY: fovy aspect: aspect near: nearDistance far: farDistance);
		hasReverseDepth: true;
		transformation: worldRenderingTransform;
		yourself
	}
]
