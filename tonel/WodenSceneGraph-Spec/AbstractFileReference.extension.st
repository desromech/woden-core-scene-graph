Extension { #name : 'AbstractFileReference' }

{ #category : '*WodenSceneGraph-Spec' }
AbstractFileReference >> inspectionWodenMaterial [
	<inspectorPresentationOrder: 0 title: 'Material'>
	^ WDSpSurfaceMaterialPresenter new 
		material: (WDMaterial loadFromFileReference: self);
		yourself
]

{ #category : '*WodenSceneGraph-Spec' }
AbstractFileReference >> inspectionWodenMaterialContext: aContext [
	aContext active: (self isFile and:[ self extension = 'wdmat' ])
]
