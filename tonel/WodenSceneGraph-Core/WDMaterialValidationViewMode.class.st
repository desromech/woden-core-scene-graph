"
I am view mode that display meshes with special colors to validate proper realistic PBR material parameters ranges.
"
Class {
	#name : #WDMaterialValidationViewMode,
	#superclass : #WDViewMode,
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #testing }
WDMaterialValidationViewMode >> isMaterialValidationViewMode [
	^ true
]
