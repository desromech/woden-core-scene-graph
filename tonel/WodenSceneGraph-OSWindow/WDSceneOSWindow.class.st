"
I am an OSWindow that is used for displaying a woden scene.
"
Class {
	#name : #WDSceneOSWindow,
	#superclass : #WDAbstractRenderingSceneStateOSWindow,
	#instVars : [
		'scene',
		'camera',
		'overlay',
		'hasSceneUpdateRequested',
		'lastSceneUpdateTime'
	],
	#category : #'WodenSceneGraph-OSWindow'
}

{ #category : #'as yet unclassified' }
WDSceneOSWindow >> buildWindowOverlaySceneGraphNodeWith: builder [
	^ builder string: 'Hello World' in: (30@30 extent: 200@100) font: TextStyle defaultFont color: Color white
]

{ #category : #accessing }
WDSceneOSWindow >> camera [

	^ camera
]

{ #category : #accessing }
WDSceneOSWindow >> camera: anObject [

	camera := anObject
]

{ #category : #'as yet unclassified' }
WDSceneOSWindow >> doUpdate [
	| currentTime deltaTime |
	currentTime := Time monotonicMicrosecondClockValue.
	lastSceneUpdateTime ifNil: [ lastSceneUpdateTime := Time monotonicMicrosecondClockValue ].
	deltaTime := currentTime - lastSceneUpdateTime.
	
	hasSceneUpdateRequested := scene updateWithDeltaTime: deltaTime*1e-6.
	
	lastSceneUpdateTime := currentTime.
]

{ #category : #initialization }
WDSceneOSWindow >> initialize [
	super initialize.
	self camera: WDCamera new.
	hasSceneUpdateRequested := false.
]

{ #category : #accessing }
WDSceneOSWindow >> leftEyeRenderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithFrustumTangents: (vrSystem leftEyeFrustumTangentsWithFovY: camera asCameraFovY aspect: aspectRatio) eyeTransform: vrSystem leftEyeTransform)
		ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : #accessing }
WDSceneOSWindow >> needsToRender [
	^ super needsToRender or: [ hasSceneUpdateRequested ]
]

{ #category : #accessing }
WDSceneOSWindow >> overlay [

	^ overlay
]

{ #category : #accessing }
WDSceneOSWindow >> overlay: anObject [

	overlay := anObject
]

{ #category : #accessing }
WDSceneOSWindow >> renderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithAspectRatio: aspectRatio) ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : #accessing }
WDSceneOSWindow >> rightEyeRenderingSceneState [
	| displayExtent aspectRatio |
	scene ifNil: [ ^ nil ].
	camera ifNil: [ ^ nil ].
	displayExtent := self displayExtent.
	aspectRatio := displayExtent x asFloat / displayExtent y.
	^ (camera asCameraStateWithFrustumTangents: (vrSystem rightEyeFrustumTangentsWithFovY: camera asCameraFovY aspect: aspectRatio) eyeTransform: vrSystem rightEyeTransform)
		ifNotNil: [ :cameraState | scene asRenderingSceneWithCameraState: cameraState ]
]

{ #category : #accessing }
WDSceneOSWindow >> scene [

	^ scene
]

{ #category : #accessing }
WDSceneOSWindow >> scene: anObject [

	scene := anObject.
	hasSceneUpdateRequested := true
]
