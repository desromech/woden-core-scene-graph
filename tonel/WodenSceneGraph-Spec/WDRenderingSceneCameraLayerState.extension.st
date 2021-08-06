Extension { #name : #WDRenderingSceneCameraLayerState }

{ #category : #'*WodenSceneGraph-Spec' }
WDRenderingSceneCameraLayerState >> inspectionRendererOutput [
	<inspectorPresentationOrder: 0 title: 'Renderer Output'>
	
	^ WDSpRenderingSceneStatePresenter new 
		renderingSceneState: self asRenderingSceneState;
		yourself
]
