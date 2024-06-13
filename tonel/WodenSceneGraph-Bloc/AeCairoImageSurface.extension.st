Extension { #name : 'AeCairoImageSurface' }

{ #category : '*WodenSceneGraph-Bloc' }
AeCairoImageSurface >> readbackDataFromAgpuTexture: agpuTexture [
	self flush.
	agpuTexture readTextureData: 0 arrayIndex: 0 pitch: self stride slicePitch: self stride * self height buffer: self data.
	self markDirty.
]
