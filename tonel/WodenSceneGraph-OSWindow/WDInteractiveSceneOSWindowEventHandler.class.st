Class {
	#name : 'WDInteractiveSceneOSWindowEventHandler',
	#superclass : 'WDAbstractRenderingSceneStateOSWindowEventHandler',
	#category : 'WodenSceneGraph-OSWindow',
	#package : 'WodenSceneGraph-OSWindow'
}

{ #category : 'visiting' }
WDInteractiveSceneOSWindowEventHandler >> visitMouseMoveEvent: anEvent [
	window ifNotNil: [ window onMouseMove: anEvent ]
]

{ #category : 'visiting' }
WDInteractiveSceneOSWindowEventHandler >> visitMouseWheelEvent: anEvent [
	window ifNotNil: [ window onMouseWheel: anEvent ]
]
