"
I am a specific method used for interpolating curve samples.
"
Class {
	#name : #WDCurveInterpolationMethod,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #testing }
WDCurveInterpolationMethod class >> asCurveInterpolationMethod [
	self assert: self isAbstract not.
	^ self uniqueInstance
]

{ #category : #testing }
WDCurveInterpolationMethod class >> isAbstract [
	^ self == WDCurveInterpolationMethod
]

{ #category : #converting }
WDCurveInterpolationMethod >> asCurveInterpolationMethod [
	^ self
]
