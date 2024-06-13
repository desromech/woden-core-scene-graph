Extension { #name : 'WDTexture' }

{ #category : '*WodenSceneGraph-Renderer-AbstractGPU' }
WDTexture >> uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache [
	| dataKind selfHandle |
	dataKind := aWDTexture dataKind.
	selfHandle := resourceCache validTextureHandleFor: self.
	dataKind isCubeEnvironmentMapData ifTrue: [
		self assert: self dataKind isHDRIData.
		self assert: aWDTexture type isCubeTextureType.
		self assert: aWDTexture width = aWDTexture height.
		^ resourceCache textureUploader convertHDRI: selfHandle extent: self width @ self height intoEnvironmentMap: agpuTexture size: aWDTexture width.
	].
	dataKind isDiffuseLightProbe ifTrue: [
		self assert: self type isCubeTextureType.
		self assert: aWDTexture type isCubeTextureType.
		self assert: aWDTexture width = aWDTexture height.
		^ resourceCache textureUploader convertEnvironmentMap: selfHandle intoDiffuseLightProbe: agpuTexture size: aWDTexture width.
	].
	dataKind isSpecularLightProbe ifTrue: [
		self assert: self type isCubeTextureType.
		self assert: aWDTexture type isCubeTextureType.
		self assert: aWDTexture width = aWDTexture height.
		^ resourceCache textureUploader convertEnvironmentMap: selfHandle intoSpecularLightProbe: agpuTexture size: aWDTexture width.
	].
	self error: 'Unsupported use case'
]
