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
		'hmdTrackedDevice',
		'isInStandbyMode',
		'convertedRenderModelDictionary',
		'convertedRenderModelTextureDictionary'
	],
	#classVars : [
		'AxisStateClassMap',
		'DeviceClassIDToClassMap',
		'DeviceRoleMap',
		'EventTypeMap'
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
	}.
	
	DeviceRoleMap := Dictionary newFromPairs: { 
		AGPU_VR_TRACKED_DEVICE_ROLE_INVALID . WDVRTrackedDeviceRoleInvalid asVRTrackedDeviceRole.
		AGPU_VR_TRACKED_DEVICE_ROLE_LEFT_HAND . WDVRTrackedDeviceRoleLeftHand asVRTrackedDeviceRole.
		AGPU_VR_TRACKED_DEVICE_ROLE_RIGHT_HAND . WDVRTrackedDeviceRoleRightHand asVRTrackedDeviceRole.
		AGPU_VR_TRACKED_DEVICE_ROLE_OPT_OUT . WDVRTrackedDeviceRoleOptOut asVRTrackedDeviceRole.
		AGPU_VR_TRACKED_DEVICE_ROLE_THREADMILL . WDVRTrackedDeviceRoleThreadmill asVRTrackedDeviceRole.
	}.
	
	EventTypeMap := Dictionary newFromPairs: {
		AGPU_VR_EVENT_TYPE_TRACKED_DEVICE_ACTIVATED . WDVRTrackedDeviceActivatedEvent.
		AGPU_VR_EVENT_TYPE_TRACKED_DEVICE_DEACTIVATED . WDVRTrackedDeviceDeactivatedEvent.
		AGPU_VR_EVENT_TYPE_TRACKED_DEVICE_UPDATED . WDVRTrackedDeviceUpdatedEvent.
		AGPU_VR_EVENT_TYPE_TRACKED_DEVICE_USER_INTERACTION_STARTED . WDVRTrackedDeviceUserInteractionStartedEvent.
		AGPU_VR_EVENT_TYPE_TRACKED_DEVICE_USER_INTERACTION_ENDED . WDVRTrackedDeviceUserInteractionEndedEvent.
		
		AGPU_VR_EVENT_TYPE_BUTTON_PRESSED . WDVRTrackedDeviceButtonPressedEvent.
		AGPU_VR_EVENT_TYPE_BUTTON_RELEASED . WDVRTrackedDeviceButtonReleasedEvent.
		AGPU_VR_EVENT_TYPE_BUTTON_TOUCH . WDVRTrackedDeviceButtonTouchEvent.
		AGPU_VR_EVENT_TYPE_BUTTON_UNTOUCH . WDVRTrackedDeviceButtonUntouchEvent.
		
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_PRESSED . WDVRTrackedDeviceDualAnalogPressedEvent.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_RELEASED . WDVRTrackedDeviceDualAnalogReleasedEvent.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_TOUCH . WDVRTrackedDeviceDualAnalogTouchEvent.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_UNTOUCH . WDVRTrackedDeviceDualAnalogUntouchEvent.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MOVE. WDVRTrackedDeviceDualAnalogMoveEvent.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MODE_SWITCH_1 . WDVRTrackedDeviceDualAnalogModeSwitch1Event.
		AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MODE_SWITCH_2 . WDVRTrackedDeviceDualAnalogModeSwitch2Event.
	}.
	
	AxisStateClassMap := Dictionary newFromPairs: { 
		AGPU_VR_CONTROLLER_AXIS_JOYSTICK . WDVRControllerJoystickAxisState.
		AGPU_VR_CONTROLLER_AXIS_TRACK_PAD . WDVRControllerTrackPadAxisState.
		AGPU_VR_CONTROLLER_AXIS_TRIGGER . WDVRControllerTriggerAxisState.
	}.
]

{ #category : #'tracked device' }
WDAGPUVRSystem >> checkTrackedDevice: oldDevice forPose: trackedDevicePose [
	| requiredClass |
	requiredClass := DeviceClassIDToClassMap at: trackedDevicePose device_class ifAbsent: [ WDVRTrackedDeviceInvalid ].
	^ oldDevice class == requiredClass
		ifTrue: [ oldDevice ]
		ifFalse: [ self newTrackedDeviceFor: trackedDevicePose ]
]

{ #category : #'as yet unclassified' }
WDAGPUVRSystem >> controllerAxisState: axisState [
	^ (AxisStateClassMap at: axisState type ifAbsent: [nil]) ifNotNil: [ :cls |
		cls new
			x: axisState x;
			y: axisState y;
			yourself
	]
]

{ #category : #'tracked device' }
WDAGPUVRSystem >> convertControllerState: state [
	^ WDVRControllerState new
		touchedButtons: state buttons_touched;
		pressedButtons: state buttons_pressed;
		axes: ({
			self controllerAxisState: state axis0 .
			self controllerAxisState: state axis1 .
			self controllerAxisState: state axis2 .
			self controllerAxisState: state axis3 .
			self controllerAxisState: state axis4 .
		} select: [ :each | each notNil ])
		yourself 
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

{ #category : #'render model' }
WDAGPUVRSystem >> convertRenderModel: agpuRenderModel [
	| modelHandle |
	(agpuRenderModel isNil or: [agpuRenderModel isNull]) ifTrue: [ ^ nil ].
	
	modelHandle := agpuRenderModel getHandle asInteger.
	^ convertedRenderModelDictionary at: modelHandle ifAbsentPut: [ 
		| material vertexCount vertexBufferView vertexBufferSize vertexBufferData positionsAccessors boundingBox vertexBinding indexCount indexBufferView indexBufferSize indexBufferData |
		material := self convertRenderModelMaterial: agpuRenderModel texture.
		
		vertexCount := agpuRenderModel vertex_count.
		vertexBufferSize := AGPUVrRenderModelVertex structureSize * vertexCount.
		vertexBufferData := ByteArray new: vertexBufferSize.
		(AGPUMemoryCopier forExternalAddress: agpuRenderModel vertices getHandle)
			copyBytes: vertexBufferSize at: 1 into: vertexBufferData at: 1.
		
		vertexBufferView := WDBinaryBufferView new
			buffer: (WDBinaryBuffer new
				data: vertexBufferData;
				yourself);
			byteLength: vertexBufferSize;
			byteStride: AGPUVrRenderModelVertex structureSize;
			yourself.
			
		positionsAccessors := WDBinaryBufferAccessor new
			bufferView: vertexBufferView;
			count: vertexCount;
			componentType: WDBinaryBufferAccessorFloat32ComponentType;
			type: WDBinaryBufferAccessorVector3Type;
			yourself.
		boundingBox := AABox empty.
		positionsAccessors decodeContentAsArray do: [ :eachPosition |
			boundingBox insertPoint: eachPosition
		].
		positionsAccessors min: boundingBox min; max: boundingBox max.
		
		vertexBinding := WDVertexBufferBinding new
			attributes: {
				WDVertexBufferAttribute new
					location: WDVertexBufferAttribute positionLocation;
					accessor: positionsAccessors;
					yourself.
				WDVertexBufferAttribute new
					location: WDVertexBufferAttribute normalLocation;
					accessor: (WDBinaryBufferAccessor new
						bufferView: vertexBufferView;
						byteOffset: 12;
						count: vertexCount;
						componentType: WDBinaryBufferAccessorFloat32ComponentType;
						type: WDBinaryBufferAccessorVector3Type;
						yourself);
					yourself.
				WDVertexBufferAttribute new
					location: WDVertexBufferAttribute texcoord0Location;
					accessor: (WDBinaryBufferAccessor new
						bufferView: vertexBufferView;
						byteOffset: 24;
						count: vertexCount;
						componentType: WDBinaryBufferAccessorFloat32ComponentType;
						type: WDBinaryBufferAccessorVector2Type;
						yourself);
					yourself.
			};
			vertexCount: vertexCount;
			yourself.

		indexCount := agpuRenderModel triangle_count * 3.
		indexBufferSize := indexCount * 2.
		indexBufferData := ByteArray new: indexBufferSize.
		(AGPUMemoryCopier forExternalAddress: agpuRenderModel indices getHandle)
			copyBytes: indexBufferSize at: 1 into: indexBufferData at: 1.

		indexBufferView := WDBinaryBufferView new
			buffer: (WDBinaryBuffer new
				data: indexBufferData;
				yourself);
			byteLength: indexBufferSize;
			byteStride: 2;
			yourself.
			
		WDStaticMeshRenderable new
			boundingBox: boundingBox;
			primitives: {
				WDMeshPrimitive new
					material: material;
					boundingBox: boundingBox;
					vertexBinding: vertexBinding;
					indices: (WDBinaryBufferAccessor new
						bufferView: indexBufferView;
						count: indexCount;
						componentType: WDBinaryBufferAccessorUInt16ComponentType;
						type: WDBinaryBufferAccessorScalarType;
						yourself);
					topology: WDPrimitiveTopologyTriangles;
					yourself
			};
			yourself
	]
]

{ #category : #'render model' }
WDAGPUVRSystem >> convertRenderModelMaterial: agpuRenderModelTexture [
	^ WDMetallicRoughnessMaterial new
		roughnessFactor: 0.7;
		metallicFactor: 0.0;
		baseColorTexture: (self convertRenderModelTexture: agpuRenderModelTexture);
		yourself
]

{ #category : #'render model' }
WDAGPUVRSystem >> convertRenderModelTexture: agpuRenderModelTexture [
	| textureHandle |
	(agpuRenderModelTexture isNil or: [agpuRenderModelTexture isNull]) ifTrue: [ ^ nil ].
	
	textureHandle := agpuRenderModelTexture getHandle asInteger.
	^ convertedRenderModelTextureDictionary at: textureHandle ifAbsentPut: [
		| width height sourcePitch sourceRow destRow destPitch form formBits copier rowSize |
		width := agpuRenderModelTexture width.
		height := agpuRenderModelTexture height.
		sourcePitch := agpuRenderModelTexture pitch.
		rowSize := width*4.
		sourceRow := 1.

		"destRow := 1 + ((height - 1) * rowSize).
		destPitch := rowSize negated."
		destRow := 1.
		destPitch := rowSize.
		form := Form extent: width@height depth: -32.
		formBits := form bits.
		copier := AGPUMemoryCopier forExternalAddress: agpuRenderModelTexture data getHandle.
		1 to: height do: [ :y |
			copier copyBytes: rowSize at: sourceRow into: formBits at: destRow.
			
			sourceRow := sourceRow + sourcePitch.
			destRow := destRow + destPitch.
		].
		
		^ WDTexture forColorForm: form
	]
]

{ #category : #'tracked device' }
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
	convertedRenderModelDictionary := Dictionary new.
	convertedRenderModelTextureDictionary := Dictionary new.
	isInStandbyMode := false.
	
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
WDAGPUVRSystem >> isInStandbyMode [
	^ isInStandbyMode
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

{ #category : #events }
WDAGPUVRSystem >> onEnterStandbyMode [
	isInStandbyMode := true.
]

{ #category : #events }
WDAGPUVRSystem >> onLeaveStandbyMode [
	isInStandbyMode := false.
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
	| eventType trackedDevice vrEventClass |
	eventType := agpuVREvent type.
	eventType = AGPU_VR_EVENT_TYPE_ENTER_STANDBY_MODE ifTrue: [ self onEnterStandbyMode ].
	eventType = AGPU_VR_EVENT_TYPE_LEAVE_STANDBY_MODE ifTrue: [ self onLeaveStandbyMode ].
	
	trackedDevices ifNil: [ ^ self ].
	trackedDevice := trackedDevices at: agpuVREvent tracked_device_index + 1 ifAbsent: [^ self].
	trackedDevice ifNil: [ ^ self ].
	
	vrEventClass := EventTypeMap at: eventType ifAbsent: [ nil ].
	vrEventClass ifNotNil: [ 
		trackedDevice processAndDispatchEvent: (vrEventClass new
			convertFromAgpuVREvent: agpuVREvent;
			yourself)
	].

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

{ #category : #accessing }
WDAGPUVRSystem >> trackedDevicesDo: aBlock [
	trackedDevices do: [ :each | each ifNotNil: [ aBlock value: each ] ]
]

{ #category : #'vr system' }
WDAGPUVRSystem >> waitAndFetchPoses [
	| trackedDevicePoseCount trackedDevicePose trackedDeviceRenderPose isValidPose trackedDevice controllerState controllerStateFetched |
	handle waitAndFetchPoses.
	
	trackedDevices ifEmpty: [ trackedDevices := Array new: handle getMaxTrackedDevicePoseCount ].

	trackedDevicePoseCount := handle getCurrentTrackedDevicePoseCount.
	trackedDevicePose := AGPUVrTrackedDevicePose new.
	trackedDeviceRenderPose := AGPUVrTrackedDevicePose new.
	controllerState := AGPUVrControllerState new.
	
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
			trackedDevice renderModel ifNil: [ 
				trackedDevice renderModel: (self convertRenderModel: (handle getTrackedDeviceRenderModel: i - 1))
			].
		
			controllerStateFetched := (handle getControllerState: i - 1 dest: controllerState) ~= 0.
			trackedDevice
				role: (DeviceRoleMap at: trackedDevicePose device_role ifAbsent: [WDVRTrackedDeviceRoleInvalid asVRTrackedDeviceRole]);
				currentPose: (self convertTrackedDevicePose: trackedDevicePose);
				currentRenderPose: (self convertTrackedDevicePose: trackedDeviceRenderPose);
				controllerState: (controllerStateFetched
					ifTrue: [self convertControllerState: controllerState]
					ifFalse: [nil]);
				yourself
		].
	].

	trackedDevices detect: [:each |
		each notNil and: [each isHeadMountedDisplay]
	] ifFound: [ :device |
		hmdTrackedDevice := device
	].
	
	"Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform translation; cr.
	Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform matrix; cr."
]
