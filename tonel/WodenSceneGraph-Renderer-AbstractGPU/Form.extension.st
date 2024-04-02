Extension { #name : #Form }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
Form >> readbackDataFromAgpuTexture: agpuTexture [
	| pitch |
	self assert: depth = 32.
	pitch := self width * 4.
	self unhibernate.
	agpuTexture readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: pitch * self height buffer: self bits.
]

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
Form >> uploadIntoWodenTexture: aWDTexture agpuHandle: agpuTexture withWodenSceneRendererResourceCache: resourceCache [
	| repeated mipmapQuality |
	repeated := true.
	mipmapQuality := aWDTexture miplevels > 1 ifTrue: [ 1 ] ifFalse: [ 0 ].
	aWDTexture dataKind isColorData ifTrue: [
		^ resourceCache textureUploader uploadForm: self intoTexture: agpuTexture repeated: repeated quality: mipmapQuality
	].
	aWDTexture dataKind isNormalMapData  ifTrue: [ 
		^ resourceCache textureUploader uploadNormalMapForm: self intoTexture: agpuTexture repeated: repeated quality: mipmapQuality
	].

	^ resourceCache textureUploader uploadNonColorForm: self intoTexture: agpuTexture repeated: repeated quality: mipmapQuality
]
