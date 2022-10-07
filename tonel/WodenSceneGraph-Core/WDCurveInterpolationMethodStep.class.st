"
I am the step function interpolation method (i.e. no interpolation).
"
Class {
	#name : #WDCurveInterpolationMethodStep,
	#superclass : #WDCurveInterpolationMethod,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #interpolation }
WDCurveInterpolationMethodStep >> interpolateQuaternionSamples: samples forChannelPosition: channelPosition [
	^ (samples at: channelPosition previousFrameIndex) normalized asQuaternion
]

{ #category : #interpolation }
WDCurveInterpolationMethodStep >> interpolateVectorSamples: samples forChannelPosition: channelPosition [
	^ samples at: channelPosition previousFrameIndex
]
