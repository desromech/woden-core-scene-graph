Extension { #name : 'WDRenderingSceneCameraLayer' }

{ #category : '*WodenSceneGraph-Spec' }
WDRenderingSceneCameraLayer >> inspectionRendererOutput [
	<inspectorPresentationOrder: 0 title: 'Renderer Output'>
	
	^ WDSpRenderingSceneStatePresenter new 
		renderingSceneState: self asRenderingScene;
		yourself
]
