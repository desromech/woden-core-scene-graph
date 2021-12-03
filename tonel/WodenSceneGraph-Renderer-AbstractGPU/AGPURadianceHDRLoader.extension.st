Extension { #name : #AGPURadianceHDRLoader }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
AGPURadianceHDRLoader >> uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache [
	aWDTexture dataKind isHDRIData ifFalse: [
		^ self asForm uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache
	].
	^ resourceCache textureUploader uploadHDRI: self intoTexture: agpuTexture
]
