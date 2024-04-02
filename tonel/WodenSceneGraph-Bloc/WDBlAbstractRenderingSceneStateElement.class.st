Class {
	#name : #WDBlAbstractRenderingSceneStateElement,
	#superclass : #BlElement,
	#category : #'WodenSceneGraph-Bloc'
}

{ #category : #initialization }
WDBlAbstractRenderingSceneStateElement >> defaultSize [
	^ 853@480
]

{ #category : #initialization }
WDBlAbstractRenderingSceneStateElement >> initialize [
	super initialize.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent
	].
	self background: (WDBlWodenColorBufferImageBackground new renderingSceneStateModel: self; yourself).
]

{ #category : #accessing }
WDBlAbstractRenderingSceneStateElement >> renderingSceneState [
	^ nil
]
