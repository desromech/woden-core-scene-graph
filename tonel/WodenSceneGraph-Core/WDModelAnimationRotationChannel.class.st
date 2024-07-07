"
I am an animation channel that alters the rotation property of a model component.
"
Class {
	#name : 'WDModelAnimationRotationChannel',
	#superclass : 'WDModelAnimationChannel',
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'as yet unclassified' }
WDModelAnimationRotationChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	subtreeChannel rotation: interpolatedSample
]

{ #category : 'as yet unclassified' }
WDModelAnimationRotationChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	transform rotation: interpolatedSample
]

{ #category : 'removing' }
WDModelAnimationRotationChannel >> applySkeletonTargetingMapping: skeletonTargetingMapping [
	outputSamples := outputSamples collect: [ :sample | (skeletonTargetingMapping transformBone: targetName rotation: sample asQuaternion) asVector4 ]
]

{ #category : 'hooks' }
WDModelAnimationRotationChannel >> computeInterpolatedSampleForChannelPosition: channelPosition [
	^ interpolationMethod interpolateQuaternionSamples: outputSamples forChannelPosition: channelPosition
]
