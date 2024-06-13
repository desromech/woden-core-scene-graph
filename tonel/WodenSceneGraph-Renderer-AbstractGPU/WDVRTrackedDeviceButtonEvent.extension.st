Extension { #name : 'WDVRTrackedDeviceButtonEvent' }

{ #category : '*WodenSceneGraph-Renderer-AbstractGPU' }
WDVRTrackedDeviceButtonEvent >> convertFromAgpuVREvent: vrEvent [
	button := vrEvent data controller button
]
