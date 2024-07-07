"
I am an animation channel that alters the translation property of a model component.
"
Class {
	#name : 'WDModelAnimationTranslationChannel',
	#superclass : 'WDModelAnimationChannel',
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'as yet unclassified' }
WDModelAnimationTranslationChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	subtreeChannel translation: interpolatedSample
]

{ #category : 'as yet unclassified' }
WDModelAnimationTranslationChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	transform translation: interpolatedSample
]

{ #category : 'removing' }
WDModelAnimationTranslationChannel >> applySkeletonTargetingMapping: skeletonTargetingMapping [
	outputSamples := outputSamples collect: [ :sample | skeletonTargetingMapping transformBone: targetName translation: sample ]
]
