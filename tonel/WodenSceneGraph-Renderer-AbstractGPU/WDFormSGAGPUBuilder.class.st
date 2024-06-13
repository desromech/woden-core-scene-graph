"
I am a Form scene graph builder that can accept Woden textures that are handled via AGPU.
"
Class {
	#name : 'WDFormSGAGPUBuilder',
	#superclass : 'FormSGAGPUBuilder',
	#instVars : [
		'resourceCache'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Renderer',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Renderer'
}

{ #category : 'accessing' }
WDFormSGAGPUBuilder >> resourceCache [

	^ resourceCache
]

{ #category : 'accessing' }
WDFormSGAGPUBuilder >> resourceCache: anObject [

	resourceCache := anObject
]

{ #category : 'node building' }
WDFormSGAGPUBuilder >> texturedRectangle: rectangle wodenTexture: wodenTexture [
	| textureViewAndTextureHandle |
	textureViewAndTextureHandle := resourceCache validTextureViewHandleFor: wodenTexture.
	^ self agpuTextureNode
		isFullyOpaque: false;
		extent: rectangle extent;
		sourceRectangle: (0@0 extent: wodenTexture width @ wodenTexture height);
		texture: textureViewAndTextureHandle second;
		view: textureViewAndTextureHandle first;
		rectangle: rectangle
]
