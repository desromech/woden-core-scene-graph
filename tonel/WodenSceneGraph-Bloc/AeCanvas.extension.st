Extension { #name : 'AeCanvas' }

{ #category : '*WodenSceneGraph-Bloc' }
AeCanvas >> setBackgroundWithSurface: aCairoSurface alpha: aDouble [

	self
		setBackgroundWith: [ cairoContext sourceSurface: aCairoSurface x: 0.0 y: 0.0 ]
 		alpha: aDouble

]
