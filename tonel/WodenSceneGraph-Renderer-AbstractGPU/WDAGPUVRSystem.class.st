"
I provide connections with the AGPU VR system.
"
Class {
	#name : #WDAGPUVRSystem,
	#superclass : #WDVRSystem,
	#instVars : [
		'sceneRenderer',
		'handle',
		'recommendedRenderTargetExtent',
		'leftEyeFrustumTangents',
		'rightEyeFrustumTangents',
		'rightEyeLocalTransform',
		'leftEyeLocalTransform',
		'trackedDevices',
		'hmdTrackedDevice'
	],
	#classVars : [
		'DeviceClassIDToClassMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-VR'
}

{ #category : #initialization }
WDAGPUVRSystem class >> initialize [

	DeviceClassIDToClassMap := Dictionary newFromPairs: { 
		AGPU_VR_TRACKED_DEVICE_CLASS_HMD . WDVRTrackedDeviceHMD .
		AGPU_VR_TRACKED_DEVICE_CLASS_CONTROLLER . WDVRTrackedDeviceController .
		AGPU_VR_TRACKED_DEVICE_CLASS_GENERIC_TRACKER . WDVRTrackedDeviceGenericTracker .
		AGPU_VR_TRACKED_DEVICE_CLASS_TRACKING_REFERENCE . WDVRTrackedDeviceTrackingReference .
		AGPU_VR_TRACKED_DEVICE_CLASS_DISPLAY_REDIRECT . WDVRTrackedDeviceDisplayRedirect .
	}
]

{ #category : #'as yet unclassified' }
WDAGPUVRSystem >> checkTrackedDevice: oldDevice forPose: trackedDevicePose [
	| requiredClass |
	requiredClass := DeviceClassIDToClassMap at: trackedDevicePose device_class ifAbsent: [ WDVRTrackedDeviceInvalid ].
	^ oldDevice class == requiredClass
		ifTrue: [ oldDevice ]
		ifFalse: [ self newTrackedDeviceFor: trackedDevicePose ]
]

{ #category : #private }
WDAGPUVRSystem >> convertEyeToHeadTransform: rawEyeMatrix [
	| t |
	t := rawEyeMatrix c4.
	
	^ ReversibleAffineTransform3D translation: (Vector3 x: t x y: t y z: t z)
]

{ #category : #private }
WDAGPUVRSystem >> convertFrustumTangents: tangents [
	^ FrustumTangents new
		left: tangents left;
		right: tangents right;
		top: tangents top;
		bottom: tangents bottom;
		yourself
]

{ #category : #'as yet unclassified' }
WDAGPUVRSystem >> convertTrackedDevicePose: originalPose [
	^ WDVRTrackedDevicePose new
		deviceToAbsoluteTransform: originalPose device_to_absolute_tracking asReversibleAffineTransform3D;
		linearVelocity: originalPose velocity asVector3;
		angularVelocity: originalPose angular_velocity asVector3;
		yourself
]

{ #category : #accessing }
WDAGPUVRSystem >> handle [

	^ handle
]

{ #category : #accessing }
WDAGPUVRSystem >> headTransform [
	hmdTrackedDevice ifNil: [ ^ super headTransform ].
	^ hmdTrackedDevice currentPose deviceToAbsoluteTransform
]

{ #category : #initialization }
WDAGPUVRSystem >> initialize [
	super initialize.
	trackedDevices := #().
	
]

{ #category : #initialization }
WDAGPUVRSystem >> initializeWithSceneRenderer: aSceneRenderer handle: aVRSystemHandle [
	"Fetch the recommended render target extent."
	| size agpuFrustumTangents rawEyeMatrix |
	sceneRenderer := aSceneRenderer.
	handle := aVRSystemHandle.
	
	size := AGPUSize2d new.
	handle getRecommendedRenderTargetSize: size.
	recommendedRenderTargetExtent := size width @ size height.
	
	"Fetch the frustum tangents"
	agpuFrustumTangents := AGPUFrustumTangents new.
	handle getProjectionFrustumTangents: AGPU_VR_EYE_LEFT frustum: agpuFrustumTangents.
	leftEyeFrustumTangents := self convertFrustumTangents: agpuFrustumTangents.

	handle getProjectionFrustumTangents: AGPU_VR_EYE_RIGHT frustum: agpuFrustumTangents.
	rightEyeFrustumTangents := self convertFrustumTangents: agpuFrustumTangents.
	
	"Fetch the transforms"
	rawEyeMatrix := AGPUMatrix4x4f new.

	handle getEyeToHeadTransform: AGPU_VR_EYE_LEFT transform: rawEyeMatrix.
	leftEyeLocalTransform := self convertEyeToHeadTransform: rawEyeMatrix.
	
	handle getEyeToHeadTransform: AGPU_VR_EYE_RIGHT transform: rawEyeMatrix.
	rightEyeLocalTransform := self convertEyeToHeadTransform: rawEyeMatrix.

]

{ #category : #testing }
WDAGPUVRSystem >> isRealVRSystem [
	^ true
]

{ #category : #eyes }
WDAGPUVRSystem >> leftEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ leftEyeFrustumTangents
]

{ #category : #accessing }
WDAGPUVRSystem >> leftEyeLocalTransform [
	^ leftEyeLocalTransform
]

{ #category : #'instance creation' }
WDAGPUVRSystem >> newTrackedDeviceFor: trackedDevicePose [
	^ (DeviceClassIDToClassMap at: trackedDevicePose device_class ifAbsent: [ WDVRTrackedDeviceInvalid ]) new
		id: trackedDevicePose device_id;
		yourself
]

{ #category : #accessing }
WDAGPUVRSystem >> perEyeFrameBufferExtentForDisplayWithExtent: displayExtent [
	^ recommendedRenderTargetExtent
]

{ #category : #'vr system' }
WDAGPUVRSystem >> pollEvents [
	| rawEvent |
	rawEvent := AGPUVrEvent new.
	
	[(handle pollEvent: rawEvent) ~= 0] whileTrue: [ 
		self processEvent: rawEvent
	]
]

{ #category : #'vr system' }
WDAGPUVRSystem >> processEvent: agpuVREvent [
	| trackedDevice |
	trackedDevices ifNil: [ ^ self ].
	trackedDevice := trackedDevices at: agpuVREvent tracked_device_index + 1 ifAbsent: [^ self].
	trackedDevice ifNil: [ ^ self ].
	trackedDevice processAndDispatchAgpuVREvent: agpuVREvent
]

{ #category : #eyes }
WDAGPUVRSystem >> rightEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ rightEyeFrustumTangents
]

{ #category : #accessing }
WDAGPUVRSystem >> rightEyeLocalTransform [
	^ rightEyeLocalTransform
]

{ #category : #accessing }
WDAGPUVRSystem >> sceneRenderer [

	^ sceneRenderer
]

{ #category : #'vr system' }
WDAGPUVRSystem >> submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeTexture rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeTexture [
	| leftEyeTextureHandle rightEyeTextureHandle |
	leftEyeTextureHandle := sceneRenderer resourceCache validTextureHandleFor: leftEyeTexture.
	rightEyeTextureHandle := sceneRenderer resourceCache validTextureHandleFor: rightEyeTexture.
	handle submitEyeRenderTargets: leftEyeTextureHandle right_eye: rightEyeTextureHandle.
	super submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeTexture rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeTexture
]

{ #category : #'vr system' }
WDAGPUVRSystem >> waitAndFetchPoses [
	| trackedDevicePoseCount trackedDevicePose trackedDeviceRenderPose isValidPose trackedDevice |
	handle waitAndFetchPoses.
	
	trackedDevices ifEmpty: [ trackedDevices := Array new: handle getMaxTrackedDevicePoseCount ].

	trackedDevicePoseCount := handle getCurrentTrackedDevicePoseCount.
	trackedDevicePose := AGPUVrTrackedDevicePose new.
	trackedDeviceRenderPose := AGPUVrTrackedDevicePose new.
	1 to: trackedDevicePoseCount do: [ :i |
		handle getCurrentTrackedDevicePoseInto: i - 1 dest: trackedDevicePose.
		handle getCurrentRenderTrackedDevicePoseInto: i - 1 dest: trackedDeviceRenderPose.
		
		isValidPose := trackedDevicePose is_valid ~= 0.
		isValidPose ifTrue: [ 
			trackedDevice := (trackedDevices at: i) ifNil: [
				self newTrackedDeviceFor: trackedDevicePose.
			] ifNotNil: [ :oldTrackedDevice |
				self checkTrackedDevice: oldTrackedDevice forPose: trackedDevicePose
			].
			trackedDevices at: i put: trackedDevice.
			trackedDevice
				currentPose: (self convertTrackedDevicePose: trackedDevicePose);
				currentRenderPose: (self convertTrackedDevicePose: trackedDeviceRenderPose);
				yourself
		].
	].

	trackedDevices detect: [:each | each isNotNil and: [each isHeadMountedDisplay]] ifFound: [ :device | hmdTrackedDevice := device ].
	
	"Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform translation; cr.
	Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform matrix; cr."
]
