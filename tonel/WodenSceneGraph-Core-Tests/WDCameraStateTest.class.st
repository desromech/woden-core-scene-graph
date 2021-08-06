"
A WDCameraStateTest is a test class for testing the behavior of WDCameraState
"
Class {
	#name : #WDCameraStateTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-RenderingState'
}

{ #category : #tests }
WDCameraStateTest >> testAsCameraStateForBackgroundLayer [
	| baseCameraState layerCamersState |
	baseCameraState := WDCameraState new
		transformation: (ReversibleAffineTransform3D rotation: (Quaternion lookAtBack) translation: (Vector3 x: 0 y: 2 z: 5));
		projectionMatrix: (Matrix4x4 perspectiveFovY: 60 aspect: 1.0 near: 0.01 far: 100.0);
		yourself.
	layerCamersState := baseCameraState asCameraStateForBackgroundLayer.
	self assert: baseCameraState projectionMatrix equals: layerCamersState projectionMatrix.
	self assert: baseCameraState transformation matrix equals: layerCamersState transformation matrix.
	self assert: baseCameraState transformation inverseMatrix equals: layerCamersState transformation inverseMatrix.
	self assert: layerCamersState transformation translation equals: Vector3 zeros.

]

{ #category : #tests }
WDCameraStateTest >> testAsCameraStateForForegroundLayer [
	| baseCameraState layerCamersState |
	baseCameraState := WDCameraState new
		transformation: (ReversibleAffineTransform3D rotation: (Quaternion lookAtBack) translation: (Vector3 x: 0 y: 2 z: 5));
		projectionMatrix: (Matrix4x4 perspectiveFovY: 60 aspect: 1.0 near: 0.01 far: 100.0);
		yourself.
	layerCamersState := baseCameraState asCameraStateForForegroundLayer.
	self assert: baseCameraState projectionMatrix equals: layerCamersState projectionMatrix.
	self assert: layerCamersState transformation equals: ReversibleAffineTransform3D identity.
]
