"
I am a specific method used for interpolating curve samples.
"
Class {
	#name : 'WDCurveInterpolationMethod',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'testing' }
WDCurveInterpolationMethod class >> asCurveInterpolationMethod [
	self assert: self isAbstract not.
	^ self uniqueInstance
]

{ #category : 'testing' }
WDCurveInterpolationMethod class >> isAbstract [
	^ self == WDCurveInterpolationMethod
]

{ #category : 'converting' }
WDCurveInterpolationMethod >> asCurveInterpolationMethod [
	^ self
]

{ #category : 'interpolation' }
WDCurveInterpolationMethod >> interpolateQuaternionSamples: samples forChannelPosition: channelPosition [
	self subclassResponsibility
]

{ #category : 'interpolation' }
WDCurveInterpolationMethod >> interpolateVectorSamples: samples forChannelPosition: channelPosition [
	self subclassResponsibility
]
