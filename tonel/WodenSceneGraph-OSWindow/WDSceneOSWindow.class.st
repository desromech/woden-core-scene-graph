"
I am an OSWindow that is used for displaying a woden scene.
"
Class {
	#name : 'WDSceneOSWindow',
	#superclass : 'WDAbstractRenderingSceneStateOSWindow',
	#instVars : [
		'scene',
		'camera',
		'overlays',
		'hasSceneUpdateRequested',
		'lastSceneUpdateTime'
	],
	#category : 'WodenSceneGraph-OSWindow',
	#package : 'WodenSceneGraph-OSWindow'
}

{ #category : 'as yet unclassified' }
WDSceneOSWindow >> buildWindowOverlaySceneGraphNodeWith: builder [
	overlays isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: (0@0 extent: self displayExtent) build: [ 
		builder containerWith: (overlays collect: [:each | each buildFullSceneGraphWith: builder])
	]
]

{ #category : 'accessing' }
WDSceneOSWindow >> camera [

	^ camera
]

{ #category : 'accessing' }
WDSceneOSWindow >> camera: anObject [

	camera := anObject
]

{ #category : 'as yet unclassified' }
WDSceneOSWindow >> doUpdate [
	| currentTime deltaTime |
	currentTime := Time monotonicMicrosecondClockValue.
	lastSceneUpdateTime ifNil: [ lastSceneUpdateTime := Time monotonicMicrosecondClockValue ].
	deltaTime := currentTime - lastSceneUpdateTime.
	
	hasSceneUpdateRequested := scene updateWithDeltaTime: deltaTime*1e-6.
	
	lastSceneUpdateTime := currentTime.
]

{ #category : 'accessing' }
WDSceneOSWindow >> headFloorTransform [
	camera cameras isEmpty ifFalse: [
		^ camera cameras first headFloorTransform
	].

	^ ReversibleAffineTransform3D identity
]

{ #category : 'as yet unclassified' }
WDSceneOSWindow >> headTransformIsIncorporatedInCamera [
	^ false
]

{ #category : 'initialization' }
WDSceneOSWindow >> initialize [
	super initialize.
	self camera: WDCamera new.
	overlays := #().
	hasSceneUpdateRequested := false.
]

{ #category : 'accessing' }
WDSceneOSWindow >> leftEyeRenderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithFrustumTangents: (vrSystem leftEyeFrustumTangentsWithFovY: camera asCameraFovY aspect: aspectRatio) eyeTransform: self leftEyeTransform)
		ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> leftEyeTransform [
	^ self headTransformIsIncorporatedInCamera
		ifTrue: [ vrSystem leftEyeLocalTransform ]
		ifFalse: [ self headFloorTransform transformTransform: vrSystem leftEyeTransform ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> needsToRender [
	^ super needsToRender or: [ hasSceneUpdateRequested ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> overlay: aWDWindowOverlay [
	aWDWindowOverlay ifNil: [ 
		self overlays: #()
	] ifNotNil: [ 
		self overlays: { aWDWindowOverlay }
	].

]

{ #category : 'accessing' }
WDSceneOSWindow >> overlays [
	^ overlays
]

{ #category : 'accessing' }
WDSceneOSWindow >> overlays: anArrayOfWDOverlay [
	overlays := anArrayOfWDOverlay.
	self changed
]

{ #category : 'accessing' }
WDSceneOSWindow >> renderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithAspectRatio: aspectRatio) ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> rightEyeRenderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithFrustumTangents: (vrSystem rightEyeFrustumTangentsWithFovY: camera asCameraFovY aspect: aspectRatio) eyeTransform: self rightEyeTransform)
		ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> rightEyeTransform [
	^ self headTransformIsIncorporatedInCamera
		ifTrue: [ vrSystem rightEyeLocalTransform ]
		ifFalse: [ self headFloorTransform transformTransform: vrSystem rightEyeTransform ]
]

{ #category : 'accessing' }
WDSceneOSWindow >> scene [

	^ scene
]

{ #category : 'accessing' }
WDSceneOSWindow >> scene: anObject [

	scene := anObject.
	hasSceneUpdateRequested := true
]
