"
I am an animation channel that alters the weights property of a model component. Weights are used shape blending according to the gltf spec. Not currently supported in WODEN.
"
Class {
	#name : 'WDModelAnimationWeightsChannel',
	#superclass : 'WDModelAnimationChannel',
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'as yet unclassified' }
WDModelAnimationWeightsChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	subtreeChannel weight: interpolatedSample
]

{ #category : 'as yet unclassified' }
WDModelAnimationWeightsChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	"Do nothing here"
]

{ #category : 'removing' }
WDModelAnimationWeightsChannel >> applySkeletonTargetingMapping: skeletonTargetingMapping [
	"Nothing is required here"
]
