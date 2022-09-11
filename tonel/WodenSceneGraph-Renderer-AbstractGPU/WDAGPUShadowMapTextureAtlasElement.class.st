Class {
	#name : #WDAGPUShadowMapTextureAtlasElement,
	#superclass : #Object,
	#instVars : [
		'offset',
		'extent',
		'atlasExtent'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Allocator'
}

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> atlasExtent [

	^ atlasExtent
]

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> atlasExtent: anObject [

	atlasExtent := anObject
]

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> extent [

	^ extent
]

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> extent: anObject [

	extent := anObject
]

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> offset [

	^ offset
]

{ #category : #accessing }
WDAGPUShadowMapTextureAtlasElement >> offset: anObject [

	offset := anObject
]
