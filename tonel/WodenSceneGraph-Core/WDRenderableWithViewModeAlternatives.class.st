Class {
	#name : 'WDRenderableWithViewModeAlternatives',
	#superclass : 'WDRenderable',
	#instVars : [
		'alternatives',
		'defaultAlternativeIsEmpty'
	],
	#category : 'WodenSceneGraph-Core-Renderable',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Renderable'
}

{ #category : 'adding' }
WDRenderableWithViewModeAlternatives >> addToRenderingScene: renderingScene withObjectState: anObjectState [
	(self getValidAlternativeFor: renderingScene viewMode) ifNotNil: [ :alternative |
		alternative addToRenderingScene: renderingScene withObjectState: anObjectState
	]
]

{ #category : 'adding' }
WDRenderableWithViewModeAlternatives >> addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState [
	(self getValidAlternativeFor: renderingScene viewMode) ifNotNil: [ :alternative |
		alternative addToRenderingScene: renderingScene withObjectState: anObjectState poseState: poseState
	]
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> boundingBox [
	^ self defaultValidAlternative
		ifNil: [ AABox originPoint ]
		ifNotNil: [ :alternative | alternative boundingBox ]
]

{ #category : 'copying' }
WDRenderableWithViewModeAlternatives >> copyTransformingMaterialsWith: aBlock [
	^ self
]

{ #category : 'copying' }
WDRenderableWithViewModeAlternatives >> copyWithMaterial: aBlock [
	^ self
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> defaultAlternative [
	^ defaultAlternativeIsEmpty
		ifTrue: [nil]
		ifFalse: [self getAlternativeFor: WDFullShadedViewMode]
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> defaultAlternativeIsEmpty [

	^ defaultAlternativeIsEmpty
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> defaultAlternativeIsEmpty: anObject [

	defaultAlternativeIsEmpty := anObject
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> defaultValidAlternative [
	^ self getAlternativeFor: WDFullShadedViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> flatColor: renderable [
	^ self setAlternative: renderable for: WDFlatColorViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> flatColorShaded: renderable [
	^ self setAlternative: renderable for: WDFlatColorShadedViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> flatTextured: renderable [
	^ self setAlternative: renderable for: WDFlatTexturedViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> fullShaded [
	^ self getAlternativeFor: WDFullShadedViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> fullShaded: renderable [
	^ self setAlternative: renderable for: WDFullShadedViewMode
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> getAlternativeFor: viewMode [
	^ alternatives at: viewMode asViewMode ifAbsent: [ nil ]
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> getValidAlternativeFor: viewMode [
	^ alternatives at: viewMode asViewMode ifAbsent: [ self defaultAlternative ]
]

{ #category : 'initialization' }
WDRenderableWithViewModeAlternatives >> initialize [
	super initialize.
	alternatives := IdentityDictionary new.
	defaultAlternativeIsEmpty := false.
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> setAlternative: anAlternative for: viewMode [
	alternatives at: viewMode asViewMode put: anAlternative
]

{ #category : 'accessing' }
WDRenderableWithViewModeAlternatives >> wireframe: renderable [
	^ self setAlternative: renderable for: WDWireframeViewMode
]
