"
I represent a specific view mode. I am typically used by the editor to specify different kind of views.
"
Class {
	#name : 'WDViewMode',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-RenderingState',
	#package : 'WodenSceneGraph-Core',
	#tag : 'RenderingState'
}

{ #category : 'converting' }
WDViewMode class >> asViewMode [
	^ self uniqueInstance
]

{ #category : 'converting' }
WDViewMode >> asViewMode [
	^ self
]

{ #category : 'testing' }
WDViewMode >> isFlatColorShadedViewMode [
	^ false
]

{ #category : 'testing' }
WDViewMode >> isFlatColorViewMode [
	^ false
]

{ #category : 'testing' }
WDViewMode >> isFlatTexturedViewMode [
	^ false
]

{ #category : 'testing' }
WDViewMode >> isFullShadedViewMode [
	^ false
]

{ #category : 'testing' }
WDViewMode >> isMaterialValidationViewMode [
	^ false
]

{ #category : 'testing' }
WDViewMode >> isWireframeViewMode [
	^ false
]
