"
I am a specific animation channel for a model.
"
Class {
	#name : #WDModelAnimationChannel,
	#superclass : #Object,
	#instVars : [
		'name',
		'targetName',
		'inputSamples',
		'inputMinValue',
		'inputMaxValue',
		'outputSamples',
		'interpolationMethod'
	],
	#category : #'WodenSceneGraph-Core-Animation'
}

{ #category : #accessing }
WDModelAnimationChannel >> inputMaxValue [

	^ inputMaxValue
]

{ #category : #accessing }
WDModelAnimationChannel >> inputMaxValue: anObject [

	inputMaxValue := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> inputMinValue [

	^ inputMinValue
]

{ #category : #accessing }
WDModelAnimationChannel >> inputMinValue: anObject [

	inputMinValue := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> inputSamples [

	^ inputSamples
]

{ #category : #accessing }
WDModelAnimationChannel >> inputSamples: anObject [

	inputSamples := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> interpolationMethod [

	^ interpolationMethod
]

{ #category : #accessing }
WDModelAnimationChannel >> interpolationMethod: anObject [

	interpolationMethod := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> name [

	^ name
]

{ #category : #accessing }
WDModelAnimationChannel >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> outputSamples [

	^ outputSamples
]

{ #category : #accessing }
WDModelAnimationChannel >> outputSamples: anObject [

	outputSamples := anObject
]

{ #category : #accessing }
WDModelAnimationChannel >> targetName [

	^ targetName
]

{ #category : #accessing }
WDModelAnimationChannel >> targetName: anObject [

	targetName := anObject
]
