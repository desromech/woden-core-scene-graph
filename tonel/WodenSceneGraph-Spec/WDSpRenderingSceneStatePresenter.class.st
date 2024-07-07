"
I am a Spec2 presenter for a Woden Rendering Scene State.
"
Class {
	#name : 'WDSpRenderingSceneStatePresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#renderingSceneState => ObservableSlot'
	],
	#category : 'WodenSceneGraph-Spec',
	#package : 'WodenSceneGraph-Spec'
}

{ #category : 'specs' }
WDSpRenderingSceneStatePresenter class >> adapterName [
	^ #WodenRenderingSceneStateAdapter
]

{ #category : 'initialization' }
WDSpRenderingSceneStatePresenter >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : 'accessing' }
WDSpRenderingSceneStatePresenter >> renderingSceneState [

	^ renderingSceneState
]

{ #category : 'accessing' }
WDSpRenderingSceneStatePresenter >> renderingSceneState: anObject [

	renderingSceneState := anObject
]

{ #category : 'enumerating' }
WDSpRenderingSceneStatePresenter >> whenRenderingSceneStateChangedDo: aBlock [
	self property: #renderingSceneState whenChangedDo: aBlock
]
