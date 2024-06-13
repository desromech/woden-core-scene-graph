Extension { #name : 'WDColorLutTextureData' }

{ #category : '*WodenSceneGraph-Renderer-AbstractGPU' }
WDColorLutTextureData >> uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache [
	agpuTexture uploadTextureData: 0 arrayIndex: 0 pitch: bytes size slicePitch: bytes size data: bytes
]
