Class {
	#name : #WDSRWGLTF2AnimationChannel,
	#superclass : #Object,
	#instVars : [
		'sampler',
		'targetArmature',
		'targetBoneIndex',
		'targetProperty'
	],
	#classVars : [
		'TargetPropertyToClassMap'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #'class initialization' }
WDSRWGLTF2AnimationChannel class >> initialize [
	TargetPropertyToClassMap := Dictionary newFromPairs: { 
		#translation . WDCSkinnedModelTranslationAnimationChannel.
		#rotation . WDCSkinnedModelRotationAnimationChannel.
		#scale . WDCSkinnedModelScaleAnimationChannel.
		#weight . WDCSkinnedModelWeightsAnimationChannel.
	}.
]

{ #category : #converting }
WDSRWGLTF2AnimationChannel >> asSkinnedModelAnimationChannel [
	^ self skinnedModelAnimationChannelClass new
		targetArmature: targetArmature;
		targetBoneIndex: targetBoneIndex;
		inputSamples: sampler inputValues;
		inputMinValue: sampler inputMinValue;
		inputMaxValue: sampler inputMaxValue;
		outputSamples: sampler outputValues;
		interpolationMethod: sampler animationInterpolationMethod;
		yourself
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> sampler [
	^ sampler
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> sampler: anObject [
	sampler := anObject
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2AnimationChannel >> skinnedModelAnimationChannelClass [
	^ TargetPropertyToClassMap at: targetProperty
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetArmature [

	^ targetArmature
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetArmature: anObject [

	targetArmature := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetBoneIndex [
	^ targetBoneIndex
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetBoneIndex: anObject [
	targetBoneIndex := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetProperty [
	^ targetProperty
]

{ #category : #accessing }
WDSRWGLTF2AnimationChannel >> targetProperty: anObject [
	targetProperty := anObject
]
