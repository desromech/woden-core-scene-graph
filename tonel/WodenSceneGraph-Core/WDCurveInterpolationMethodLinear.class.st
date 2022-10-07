"
I am a linear curve interpolation method.
"
Class {
	#name : #WDCurveInterpolationMethodLinear,
	#superclass : #WDCurveInterpolationMethod,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #interpolation }
WDCurveInterpolationMethodLinear >> interpolateQuaternionSamples: samples forChannelPosition: channelPosition [
	| previousSample nextSample |
	previousSample := samples at: channelPosition previousFrameIndex.
	nextSample := samples at: channelPosition nextFrameIndex.
	(previousSample dot: nextSample) < 0.0 ifTrue: [ 
		nextSample := nextSample negated
	].
	^ (previousSample interpolateTo: nextSample at: channelPosition alpha) normalized asQuaternion
]

{ #category : #interpolation }
WDCurveInterpolationMethodLinear >> interpolateVectorSamples: samples forChannelPosition: channelPosition [
	^ (samples at: channelPosition previousFrameIndex)
		interpolateTo: (samples at: channelPosition nextFrameIndex)
		at: channelPosition alpha
]
