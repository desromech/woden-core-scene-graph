"
I encapsulate the skinning matrices for a specific pose for a skeletal mesh.
"
Class {
	#name : #WDRenderingPoseState,
	#superclass : #Object,
	#instVars : [
		'skinningMatrices'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDRenderingPoseState >> skinningMatrices [

	^ skinningMatrices
]

{ #category : #accessing }
WDRenderingPoseState >> skinningMatrices: anObject [

	skinningMatrices := anObject
]
