"
I am a Spec2 presenter for a Woden Scene.
"
Class {
	#name : 'WDSpScenePresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#scene => ObservableSlot',
		'#camera => ObservableSlot',
		'#overlay => ObservableSlot'
	],
	#category : 'WodenSceneGraph-Spec',
	#package : 'WodenSceneGraph-Spec'
}

{ #category : 'specs' }
WDSpScenePresenter class >> adapterName [
	^ #WodenSceneAdapter
]

{ #category : 'accessing' }
WDSpScenePresenter >> camera [

	^ camera
]

{ #category : 'accessing' }
WDSpScenePresenter >> camera: anObject [

	camera := anObject
]

{ #category : 'accessing' }
WDSpScenePresenter >> overlay [

	^ overlay
]

{ #category : 'accessing' }
WDSpScenePresenter >> overlay: anObject [

	overlay := anObject
]

{ #category : 'API - changes' }
WDSpScenePresenter >> refresh [
	self scene: scene; camera: camera; overlay: overlay.
]

{ #category : 'accessing' }
WDSpScenePresenter >> scene [

	^ scene
]

{ #category : 'accessing' }
WDSpScenePresenter >> scene: anObject [

	scene := anObject
]

{ #category : 'enumerating' }
WDSpScenePresenter >> whenCameraChangedDo: aBlock [
	self property: #camera whenChangedDo: aBlock
]

{ #category : 'enumerating' }
WDSpScenePresenter >> whenOverlayChangedDo: aBlock [
	self property: #overlay whenChangedDo: aBlock
]

{ #category : 'enumerating' }
WDSpScenePresenter >> whenSceneChangedDo: aBlock [
	self property: #scene whenChangedDo: aBlock
]
