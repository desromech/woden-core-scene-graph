"
I am a Spec2 presenter for a Woden Scene.
"
Class {
	#name : #WDSpScenePresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'#scene => ObservableSlot',
		'#camera => ObservableSlot'
	],
	#category : #'WodenSceneGraph-Spec'
}

{ #category : #specs }
WDSpScenePresenter class >> adapterName [
	^ #WodenSceneAdapter
]

{ #category : #accessing }
WDSpScenePresenter >> camera [

	^ camera
]

{ #category : #accessing }
WDSpScenePresenter >> camera: anObject [

	camera := anObject
]

{ #category : #accessing }
WDSpScenePresenter >> scene [

	^ scene
]

{ #category : #accessing }
WDSpScenePresenter >> scene: anObject [

	scene := anObject
]

{ #category : #'as yet unclassified' }
WDSpScenePresenter >> sceneChanged [
	self scene: scene
]

{ #category : #enumerating }
WDSpScenePresenter >> whenCameraChangedDo: aBlock [
	self property: #camera whenChangedDo: aBlock
]

{ #category : #enumerating }
WDSpScenePresenter >> whenSceneChangedDo: aBlock [
	self property: #scene whenChangedDo: aBlock
]
