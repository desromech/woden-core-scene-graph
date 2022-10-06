Class {
	#name : #WDSRWGLTF2AnimationChannel,
	#superclass : #Object,
	#instVars : [
		'sampler',
		'targetProperty',
		'targetName'
	],
	#classVars : [
		'TargetPropertyToClassMap'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #'class initialization' }
WDSRWGLTF2AnimationChannel class >> initialize [
	TargetPropertyToClassMap := Dictionary newFromPairs: { 
		#translation . WDModelAnimationTranslationChannel.
		#rotation . WDModelAnimationRotationChannel.
		#scale . WDModelAnimationScaleChannel.
		#weight . WDModelAnimationWeightsChannel.
	}.
]

{ #category : #converting }
WDSRWGLTF2AnimationChannel >> asModelAnimationChannel [
	^ self modelAnimationChannelClass new
		targetName: targetName;
		inputSamples: sampler inputValues;
		inputMinValue: sampler inputMinValue;
		inputMaxValue: sampler inputMaxValue;
		outputSamples: sampler outputValues;
		interpolationMethod: sampler animationInterpolationMethod;
		yourself
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2AnimationChannel >> modelAnimationChannelClass [
	^ TargetPropertyToClassMap at: targetProperty
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> sampler [
	^ sampler
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> sampler: anObject [
	sampler := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetName [

	^ targetName
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetName: anObject [

	targetName := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetProperty [
	^ targetProperty
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetProperty: anObject [
	targetProperty := anObject
]
