"
I represent a form surface to be used by host renderer and host space.

When used, rendering happens in an internal Form and than can be used by a Woden texture.

"
Class {
	#name : 'WDBlTextureFormSurface',
	#superclass : 'BlHostRendererSurface',
	#instVars : [
		'form'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'initialization' }
WDBlTextureFormSurface >> createSpaceRendererOn: anObject [

	^ anObject createFormSpaceRenderer
]

{ #category : 'initialization' }
WDBlTextureFormSurface >> createSurfaceRendererOn: anObject [
	
	^ anObject createFormSurfaceRenderer
]

{ #category : 'geometry' }
WDBlTextureFormSurface >> extent [
	^ form extent
]

{ #category : 'accessing' }
WDBlTextureFormSurface >> form [
	^ form
]

{ #category : 'accessing' }
WDBlTextureFormSurface >> form: aForm [
	self assert: aForm depth = 32.
	form := aForm
]

{ #category : 'accessing' }
WDBlTextureFormSurface >> pointer [
	form unhibernate.
	^ form bits tfPointerAddress
]

{ #category : 'accessing' }
WDBlTextureFormSurface >> stride [
	^ form width * 4
]
