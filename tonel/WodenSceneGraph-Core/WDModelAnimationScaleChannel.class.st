"
I am an animation channel that alters the scale property of a model component.
"
Class {
	#name : #WDModelAnimationScaleChannel,
	#superclass : #WDModelAnimationChannel,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #'as yet unclassified' }
WDModelAnimationScaleChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	subtreeChannel scale: interpolatedSample
]

{ #category : #'as yet unclassified' }
WDModelAnimationScaleChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	transform scale: interpolatedSample
]
