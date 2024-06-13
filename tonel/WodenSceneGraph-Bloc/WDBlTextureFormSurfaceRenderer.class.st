Class {
	#name : 'WDBlTextureFormSurfaceRenderer',
	#superclass : 'BlHostSurfaceRenderer',
	#instVars : [
		'texture'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'initialization' }
WDBlTextureFormSurfaceRenderer >> initializeForSurface: aSurface [
	aSurface form: texture data
]

{ #category : 'rendering' }
WDBlTextureFormSurfaceRenderer >> renderSurface: aSurface damaged: aCollectionOfRectangles [
	texture changed
]

{ #category : 'accessing' }
WDBlTextureFormSurfaceRenderer >> texture [

	^ texture
]

{ #category : 'accessing' }
WDBlTextureFormSurfaceRenderer >> texture: anObject [

	texture := anObject
]
