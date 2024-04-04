"
I am Bloc host space whose render space is a Woden texture.
"
Class {
	#name : #WDBlTextureHostSpace,
	#superclass : #Object,
	#traits : 'TBlHostSpace + TBlSpaceProperties',
	#classTraits : 'TBlHostSpace classTrait + TBlSpaceProperties classTrait',
	#instVars : [
		'texture',
		'eventFetcher'
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

{ #category : #initialization }
WDBlTextureHostSpace >> enqueueEvent: aBlEvent [
	"I put events in a queue to be processed later"

	self eventFetcher enqueueEvent: aBlEvent
]

{ #category : #initialization }
WDBlTextureHostSpace >> eventFetcher [
	"Return event fetcher used to enqueue events that should be
	processed in the beginning of every frame"
	<return: #BlHostEventFetcher>

	^ eventFetcher
]

{ #category : #initialization }
WDBlTextureHostSpace >> fetchedEventsDo: aBlock [
	"Flush event queue and evaluate a given block with every queued event as argument"
	
	self eventFetcher fetchedEventsDo: aBlock
]

{ #category : #initialization }
WDBlTextureHostSpace >> initialize [
	super initialize.
	
	eventFetcher := BlHostEventFetcher hostSpace: self.
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
