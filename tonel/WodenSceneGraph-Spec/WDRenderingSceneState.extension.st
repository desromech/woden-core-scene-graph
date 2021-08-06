Extension { #name : #WDRenderingSceneState }

{ #category : #'*WodenSceneGraph-Spec' }
WDRenderingSceneState >> inspectionRendererOutput [
	<inspectorPresentationOrder: 0 title: 'Renderer Output'>
	
	^ WDSpRenderingSceneStatePresenter new 
		renderingSceneState: self;
		yourself
]
