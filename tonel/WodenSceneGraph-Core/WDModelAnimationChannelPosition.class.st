"
I hold the required state from an animation channel for computing the key frame positions and their interpolated position.
"
Class {
	#name : 'WDModelAnimationChannelPosition',
	#superclass : 'Object',
	#instVars : [
		'position',
		'inputSample',
		'inputMinValue',
		'inputMaxValue',
		'inputSamples',
		'isLooped',
		'actualPosition',
		'previousFramePosition',
		'previousFrameIndex',
		'nextFramePosition',
		'nextFrameIndex',
		'alpha'
	],
	#category : 'WodenSceneGraph-Core-Animation',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Animation'
}

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> actualPosition [

	^ actualPosition
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> actualPosition: anObject [

	actualPosition := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> alpha [

	^ alpha
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> alpha: anObject [

	alpha := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputMaxValue [

	^ inputMaxValue
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputMaxValue: anObject [

	inputMaxValue := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputMinValue [

	^ inputMinValue
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputMinValue: anObject [

	inputMinValue := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputSample [

	^ inputSample
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputSample: anObject [

	inputSample := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputSamples [

	^ inputSamples
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> inputSamples: anObject [

	inputSamples := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> isLooped [

	^ isLooped
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> isLooped: anObject [

	isLooped := anObject
]

{ #category : 'testing' }
WDModelAnimationChannelPosition >> isValidForPosition: newPosition looped: newIsLooped inputMinValue: newInputMinValue inputMaxValue: newInputMaxValue inputSamples: newInputSamples [
	^ position = newPosition and: [
	isLooped = newIsLooped and: [
	inputMinValue = newInputMinValue and: [
	inputMaxValue = newInputMaxValue and: [
	inputSamples == newInputSamples ]]]]
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> nextFrameIndex [

	^ nextFrameIndex
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> nextFrameIndex: anObject [

	nextFrameIndex := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> nextFramePosition [

	^ nextFramePosition
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> nextFramePosition: anObject [

	nextFramePosition := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> position [

	^ position
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> previousFrameIndex [

	^ previousFrameIndex
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> previousFrameIndex: anObject [

	previousFrameIndex := anObject
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> previousFramePosition [

	^ previousFramePosition
]

{ #category : 'accessing' }
WDModelAnimationChannelPosition >> previousFramePosition: anObject [

	previousFramePosition := anObject
]
