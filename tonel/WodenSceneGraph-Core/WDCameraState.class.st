"
I encapsulate the rendering state for a camera.
"
Class {
	#name : #WDCameraState,
	#superclass : #WDRenderingObjectState,
	#instVars : [
		'projectionMatrix',
		'frustum',
		'nearDistance',
		'farDistance',
		'currentTime',
		'exposure',
		'hasReverseDepth',
		'toneMappingOperator',
		'viewMode',
		'framebufferWidth',
		'framebufferHeight',
		'lightGridColumns',
		'lightGridRows',
		'lightGridSlices',
		'inverseProjectionMatrix',
		'hasTopLeftNDCOrigin',
		'hasBottomLeftTextureCoordinates',
		'worldFrustum',
		'bloomThreshold',
		'bloomStrength'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #converting }
WDCameraState >> asCameraStateForBackgroundLayer [
	^ self copy
		transformation: (transformation copy
			translation: Vector3 zeros;
			yourself);
		yourself
]

{ #category : #converting }
WDCameraState >> asCameraStateForForegroundLayer [
	^ self copy
		transformation: ReversibleAffineTransform3D identity;
		yourself
]

{ #category : #accessing }
WDCameraState >> bloomStrength [

	^ bloomStrength
]

{ #category : #accessing }
WDCameraState >> bloomStrength: anObject [

	bloomStrength := anObject
]

{ #category : #accessing }
WDCameraState >> bloomThreshold [

	^ bloomThreshold
]

{ #category : #accessing }
WDCameraState >> bloomThreshold: anObject [

	bloomThreshold := anObject
]

{ #category : #accessing }
WDCameraState >> currentTime [

	^ currentTime
]

{ #category : #accessing }
WDCameraState >> currentTime: anObject [

	currentTime := anObject
]

{ #category : #accessing }
WDCameraState >> exposure [

	^ exposure
]

{ #category : #accessing }
WDCameraState >> exposure: anObject [

	exposure := anObject
]

{ #category : #accessing }
WDCameraState >> farDistance [

	^ farDistance
]

{ #category : #accessing }
WDCameraState >> farDistance: anObject [

	farDistance := anObject
]

{ #category : #'as yet unclassified' }
WDCameraState >> framebufferExtent [
	^ Vector2 x: framebufferWidth y: framebufferHeight
]

{ #category : #accessing }
WDCameraState >> framebufferHeight [

	^ framebufferHeight
]

{ #category : #accessing }
WDCameraState >> framebufferHeight: anObject [

	framebufferHeight := anObject
]

{ #category : #'as yet unclassified' }
WDCameraState >> framebufferReciprocalExtent [
	^ Vector2 x: framebufferWidth reciprocal y: framebufferHeight reciprocal
]

{ #category : #accessing }
WDCameraState >> framebufferReciprocalHeight [

	^ framebufferHeight reciprocal
]

{ #category : #accessing }
WDCameraState >> framebufferReciprocalWidth [

	^ framebufferWidth reciprocal
]

{ #category : #accessing }
WDCameraState >> framebufferWidth [

	^ framebufferWidth
]

{ #category : #accessing }
WDCameraState >> framebufferWidth: anObject [

	framebufferWidth := anObject
]

{ #category : #accessing }
WDCameraState >> frustum [

	^ frustum
]

{ #category : #accessing }
WDCameraState >> frustum: aFrustum [
	frustum := aFrustum.
	worldFrustum := nil
]

{ #category : #accessing }
WDCameraState >> hasBottomLeftTextureCoordinates [

	^ hasBottomLeftTextureCoordinates
]

{ #category : #accessing }
WDCameraState >> hasBottomLeftTextureCoordinates: anObject [

	hasBottomLeftTextureCoordinates := anObject
]

{ #category : #accessing }
WDCameraState >> hasReverseDepth [

	^ hasReverseDepth
]

{ #category : #accessing }
WDCameraState >> hasReverseDepth: anObject [

	hasReverseDepth := anObject
]

{ #category : #accessing }
WDCameraState >> hasTopLeftNDCOrigin [

	^ hasTopLeftNDCOrigin
]

{ #category : #accessing }
WDCameraState >> hasTopLeftNDCOrigin: anObject [

	hasTopLeftNDCOrigin := anObject
]

{ #category : #initialization }
WDCameraState >> initialize [
	super initialize.
	projectionMatrix := Matrix4x4 identity.
	frustum := Frustum new.
	currentTime := 0.0.
	exposure := 1.0.
	bloomThreshold := 1.0.
	bloomStrength := 0.2.
	hasReverseDepth := true.
	hasTopLeftNDCOrigin := true.
	hasBottomLeftTextureCoordinates := false.
	lightGridColumns := 1.
	lightGridRows := 1.
	lightGridSlices := 1.
	self toneMappingOperator: WDLinearToneMappingOperator.
	self viewMode: WDFullShadedViewMode.
]

{ #category : #accessing }
WDCameraState >> inverseProjectionMatrix [
	^ inverseProjectionMatrix ifNil: [inverseProjectionMatrix := projectionMatrix inverse]
]

{ #category : #accessing }
WDCameraState >> lightGridColumns [

	^ lightGridColumns
]

{ #category : #accessing }
WDCameraState >> lightGridColumns: anObject [

	lightGridColumns := anObject
]

{ #category : #'as yet unclassified' }
WDCameraState >> lightGridDepthSliceOffset [
	"Formula from: http://www.aortiz.me/2018/12/21/CG.html#building-a-cluster-grid [August 2022]"
	^ lightGridSlices negated * nearDistance ln / (farDistance / nearDistance) ln
]

{ #category : #'as yet unclassified' }
WDCameraState >> lightGridDepthSliceScale [
	"Formula from: http://www.aortiz.me/2018/12/21/CG.html#building-a-cluster-grid [August 2022]"
	^ lightGridSlices / (farDistance / nearDistance) ln
]

{ #category : #'as yet unclassified' }
WDCameraState >> lightGridDepthSliceScaleOffset [
	^ Vector2 x: self lightGridDepthSliceScale y: self lightGridDepthSliceOffset
]

{ #category : #'as yet unclassified' }
WDCameraState >> lightGridExtent [
	^ Vector3 x: lightGridColumns y: lightGridRows z: lightGridSlices
]

{ #category : #accessing }
WDCameraState >> lightGridRows [

	^ lightGridRows
]

{ #category : #accessing }
WDCameraState >> lightGridRows: anObject [

	lightGridRows := anObject
]

{ #category : #accessing }
WDCameraState >> lightGridSlices [

	^ lightGridSlices
]

{ #category : #accessing }
WDCameraState >> lightGridSlices: anObject [

	lightGridSlices := anObject
]

{ #category : #accessing }
WDCameraState >> nearDistance [

	^ nearDistance
]

{ #category : #accessing }
WDCameraState >> nearDistance: anObject [

	nearDistance := anObject
]

{ #category : #accessing }
WDCameraState >> projectionMatrix [

	^ projectionMatrix
]

{ #category : #accessing }
WDCameraState >> projectionMatrix: anObject [
	projectionMatrix := anObject.
	inverseProjectionMatrix := nil.
]

{ #category : #accessing }
WDCameraState >> toneMappingOperator [

	^ toneMappingOperator
]

{ #category : #accessing }
WDCameraState >> toneMappingOperator: aToneMapOperator [
	toneMappingOperator := aToneMapOperator asToneMappingOperator
]

{ #category : #accessing }
WDCameraState >> transformation: aTransform [
	super transformation: aTransform.
	worldFrustum := nil
]

{ #category : #accessing }
WDCameraState >> viewMode [

	^ viewMode
]

{ #category : #accessing }
WDCameraState >> viewMode: aViewMode [
	viewMode := aViewMode asViewMode
]

{ #category : #accessing }
WDCameraState >> worldFrustum [
	^ worldFrustum ifNil: [ worldFrustum := frustum transformedWith: transformation ]
]
