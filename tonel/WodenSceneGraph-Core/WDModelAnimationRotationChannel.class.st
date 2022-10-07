"
I am an animation channel that alters the rotation property of a model component.
"
Class {
	#name : #WDModelAnimationRotationChannel,
	#superclass : #WDModelAnimationChannel,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #'as yet unclassified' }
WDModelAnimationRotationChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	transform rotation: interpolatedSample
]

{ #category : #hooks }
WDModelAnimationRotationChannel >> computeInterpolatedSampleForChannelPosition: channelPosition [
	^ interpolationMethod interpolateQuaternionSamples: outputSamples forChannelPosition: channelPosition
]
