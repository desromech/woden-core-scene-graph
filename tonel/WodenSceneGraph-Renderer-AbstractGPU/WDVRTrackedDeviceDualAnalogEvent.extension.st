Extension { #name : 'WDVRTrackedDeviceDualAnalogEvent' }

{ #category : '*WodenSceneGraph-Renderer-AbstractGPU' }
WDVRTrackedDeviceDualAnalogEvent >> convertFromAgpuVREvent: vrEvent [
	| agpuDualAnalog |
	agpuDualAnalog := vrEvent data dual_analog.
	position := Vector2 x: agpuDualAnalog x y: agpuDualAnalog y.
	transformedPosition := Vector2 x: agpuDualAnalog transformed_x y: agpuDualAnalog transformed_y.
	which := agpuDualAnalog which
]
