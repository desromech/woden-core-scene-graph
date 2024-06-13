"
I am a Bloc element for displaying a specific Woden rendering scene state.
"
Class {
	#name : 'WDBlAbstractRenderingSceneStateElement',
	#superclass : 'BlElement',
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'initialization' }
WDBlAbstractRenderingSceneStateElement >> defaultSize [
	^ 853@480
]

{ #category : 'hooks - children' }
WDBlAbstractRenderingSceneStateElement >> destroyResources [
	"Hook for destroying rendering resources."
]

{ #category : 'initialization' }
WDBlAbstractRenderingSceneStateElement >> initialize [
	super initialize.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent
	].
	self background: (WDBlWodenColorBufferImageBackground new renderingSceneStateModel: self; yourself).
]

{ #category : 'hooks - children' }
WDBlAbstractRenderingSceneStateElement >> onRemovedFromSceneGraph [
	self destroyResources.
	super onRemovedFromSceneGraph
]

{ #category : 'accessing' }
WDBlAbstractRenderingSceneStateElement >> renderingSceneState [
	^ nil
]
