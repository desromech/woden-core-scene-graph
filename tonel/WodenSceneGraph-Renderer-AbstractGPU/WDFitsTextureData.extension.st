Extension { #name : #WDFitsTextureData }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
WDFitsTextureData >> uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache [
	agpuTexture uploadTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch data: bytes
]
