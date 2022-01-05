"
I am a specification for a camera.
"
Class {
	#name : #WDCamera,
	#superclass : #Object,
	#instVars : [
		'nearDistance',
		'farDistance',
		'fovY',
		'focalDistance',
		'isPerspective',
		'hasReverseDepth',
		'currentTime',
		'exposure',
		'toneMappingOperator'
	],
	#category : #'WodenSceneGraph-Core-Camera'
}

{ #category : #converting }
WDCamera >> asCameraStateWithAspectRatio: aspectRatio [
	^ WDCameraState new
		nearDistance: nearDistance;
		farDistance: farDistance;
		projectionMatrix: (self projectionMatrixWithAspect: aspectRatio);
		currentTime: currentTime;
		exposure: exposure;
		toneMappingOperator: toneMappingOperator;
		hasReverseDepth: hasReverseDepth;
		yourself
]

{ #category : #converting }
WDCamera >> asSceneElement [
	^ self asSceneNode
]

{ #category : #converting }
WDCamera >> asSceneNode [
	^ WDSceneNode new
		cameras: { self };
		yourself
]

{ #category : #accessing }
WDCamera >> currentTime [

	^ currentTime
]

{ #category : #accessing }
WDCamera >> currentTime: anObject [

	currentTime := anObject
]

{ #category : #accessing }
WDCamera >> exposure [

	^ exposure
]

{ #category : #accessing }
WDCamera >> exposure: anObject [

	exposure := anObject
]

{ #category : #accessing }
WDCamera >> farDistance [

	^ farDistance
]

{ #category : #accessing }
WDCamera >> farDistance: anObject [

	farDistance := anObject
]

{ #category : #accessing }
WDCamera >> focalDistance [

	^ focalDistance
]

{ #category : #accessing }
WDCamera >> focalDistance: anObject [

	focalDistance := anObject
]

{ #category : #accessing }
WDCamera >> fovY [

	^ fovY
]

{ #category : #accessing }
WDCamera >> fovY: anObject [

	fovY := anObject
]

{ #category : #accessing }
WDCamera >> hasReverseDepth [

	^ hasReverseDepth
]

{ #category : #accessing }
WDCamera >> hasReverseDepth: anObject [

	hasReverseDepth := anObject
]

{ #category : #initialization }
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
	self toneMappingOperator: WDLinearToneMappingOperator.
]

{ #category : #accessing }
WDCamera >> isPerspective [

	^ isPerspective
]

{ #category : #accessing }
WDCamera >> isPerspective: anObject [

	isPerspective := anObject
]

{ #category : #accessing }
WDCamera >> nearDistance [

	^ nearDistance
]

{ #category : #accessing }
WDCamera >> nearDistance: anObject [

	nearDistance := anObject
]

{ #category : #converting }
WDCamera >> projectionMatrixWithAspect: aspectRatio [
	^ isPerspective ifTrue: [ 
		hasReverseDepth
			ifTrue: [ Matrix4x4 reverseDepthPerspectiveFovY: fovY aspect: aspectRatio near: nearDistance far: farDistance ]
			ifFalse: [ Matrix4x4 perspectiveFovY: fovY aspect: aspectRatio near: nearDistance far: farDistance ]
	] ifFalse: [
		| hh hw |
		hh := (fovY / 2 ) degreesToRadians tan * focalDistance.
		hw := hh * aspectRatio.
		^ Matrix4x4 reverseDepthOrthoLeft: hw negated right: hw
			bottom: hh negated top: hh
			near: nearDistance far: farDistance
	]
]

{ #category : #accessing }
WDCamera >> toneMappingOperator [

	^ toneMappingOperator
]

{ #category : #accessing }
WDCamera >> toneMappingOperator: aToneMappingOperator [
	toneMappingOperator := aToneMappingOperator asToneMappingOperator
]
