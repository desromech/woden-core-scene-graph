Extension { #name : #WDRenderingScene }

{ #category : #'*WodenSceneGraph-Spec' }
WDRenderingScene >> inspectionRendererOutput [
	<inspectorPresentationOrder: 0 title: 'Renderer Output'>
	
	^ WDSpRenderingSceneStatePresenter new 
		renderingSceneState: self;
		yourself
]
