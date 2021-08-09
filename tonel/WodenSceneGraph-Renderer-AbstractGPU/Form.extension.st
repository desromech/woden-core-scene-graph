Extension { #name : #Form }

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
