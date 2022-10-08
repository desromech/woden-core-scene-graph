"
I am an animation channel that alters the translation property of a model component.
"
Class {
	#name : #WDModelAnimationTranslationChannel,
	#superclass : #WDModelAnimationChannel,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #'as yet unclassified' }
WDModelAnimationTranslationChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	subtreeChannel translation: interpolatedSample
]

{ #category : #'as yet unclassified' }
WDModelAnimationTranslationChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	transform translation: interpolatedSample
]
