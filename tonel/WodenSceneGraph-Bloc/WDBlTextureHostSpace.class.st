"
I am Bloc host space whose render space is a Woden texture.
"
Class {
	#name : #WDBlTextureHostSpace,
	#superclass : #Object,
	#traits : 'TBlHostSpace + TBlSpaceProperties',
	#classTraits : 'TBlHostSpace classTrait + TBlSpaceProperties classTrait',
	#instVars : [
		'texture'
	],
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #'host space - displaying' }
WDBlTextureHostSpace >> close [
]

{ #category : #initialization }
WDBlTextureHostSpace >> createFormSurfaceRenderer [
	<return: #BlHostSurfaceRenderer>
	
	^ WDBlTextureFormSurfaceRenderer new texture: texture
]

{ #category : #'host space - cursor' }
WDBlTextureHostSpace >> cursor: aCursor [
	"Do nothing for now."
]

{ #category : #'host space - geometry' }
WDBlTextureHostSpace >> densityDpi [
	"Return the screen density expressed as dots-per-inch (a float)"
	
	^ 96.0
]

{ #category : #'host space - geometry' }
WDBlTextureHostSpace >> logicalSize [
	^ (texture width @ texture height) asLogicalSize
]

{ #category : #testing }
WDBlTextureHostSpace >> needsRebuild [
	"Return true if window should be recreated after user saved and quit pharo"
	<return: #Boolean>

	^ false
]

{ #category : #'instance creation' }
WDBlTextureHostSpace >> newBlHostRendererSurface [

	^ WDBlTextureFormSurface newForHostSpace: self
]

{ #category : #'host space - geometry' }
WDBlTextureHostSpace >> physicalSize [
	^ (texture width @ texture height) asPhysicalSize
]

{ #category : #'host space - rendering' }
WDBlTextureHostSpace >> requestRedraw [
	texture changed
]

{ #category : #'host space - displaying' }
WDBlTextureHostSpace >> show [
	
]

{ #category : #accessing }
WDBlTextureHostSpace >> texture [

	^ texture
]

{ #category : #accessing }
WDBlTextureHostSpace >> texture: anObject [

	texture := anObject
]

{ #category : #'host space - geometry' }
WDBlTextureHostSpace >> windowExtent: anExtent [
	"By default do nothing."
]