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

{ #category : #'as yet unclassified' }
WDModelAnimationChannel >> applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDModelAnimationChannel >> applyInterpolatedSample: interpolatedSample toTransform: transform [
	self subclassResponsibility
]

{ #category : #animation }
WDModelAnimationChannel >> applyPosition: position looped: isLooped inputSampleCache: inputSampleCache toBonePose: bonePose [
	| channelPosition interpolatedSample |
	channelPosition := self computeChannelPositionFor: position looped: isLooped inputSampleCache: inputSampleCache.
	interpolatedSample := self computeInterpolatedSampleForChannelPosition: channelPosition.
	self applyInterpolatedSample: interpolatedSample toTransform: bonePose.
	^ channelPosition
]

{ #category : #animation }
WDModelAnimationChannel >> applyPosition: position looped: isLooped inputSampleCache: inputSampleCache toSubtreeChannel: subtreeChannel [
	| channelPosition interpolatedSample |
	channelPosition := self computeChannelPositionFor: position looped: isLooped inputSampleCache: inputSampleCache.
	interpolatedSample := self computeInterpolatedSampleForChannelPosition: channelPosition.
	self applyInterpolatedSample: interpolatedSample toSubtreeChannel: subtreeChannel.
	^ channelPosition
]

{ #category : #animation }
WDModelAnimationChannel >> computeChannelPositionFor: position looped: isLooped inputSampleCache: inputSampleCache [
	| result actualPosition nextFrameIndex previousFrameIndex previousFramePosition nextFramePosition alpha |
	result := inputSampleCache ifNil: [ WDModelAnimationChannelPosition new ].
	(result isValidForPosition: position looped: isLooped inputMinValue: inputMinValue inputMaxValue: inputMaxValue inputSamples: inputSamples) ifTrue: [ ^ result ].

	actualPosition := isLooped
		ifTrue: [ position floorModule: inputMaxValue ]
		ifFalse: [ position min: inputMaxValue max: inputMinValue ].

	actualPosition <= inputMinValue ifTrue: [
		previousFrameIndex := nextFrameIndex := 1 min: inputSamples size.
		previousFramePosition := nextFramePosition := inputSamples first.
		alpha := 0.0.
	] ifFalse: [ 
		actualPosition >= inputMaxValue ifTrue: [
			previousFrameIndex := nextFrameIndex := inputSamples size.
			previousFramePosition := nextFramePosition := inputSamples last.
			alpha := 0.0.
		] ifFalse: [
			previousFrameIndex := self lowerBoundSearchPosition: actualPosition.
			nextFrameIndex := previousFrameIndex + 1 min: inputSamples size.

			previousFramePosition := inputSamples at: previousFrameIndex.
			nextFramePosition := inputSamples at: nextFrameIndex.
			alpha := (previousFramePosition closeTo: nextFramePosition)
				ifTrue: [ 0.0 ]
				ifFalse: [ (actualPosition - previousFramePosition) / (nextFramePosition - previousFramePosition) ].
		]
	].

	^ result
		position: position;
		isLooped: isLooped;
		inputMinValue: inputMinValue;
		inputMaxValue: inputMaxValue;
		inputSamples: inputSamples;
		actualPosition: actualPosition;
		previousFrameIndex: previousFrameIndex;
		previousFramePosition: previousFramePosition;
		nextFrameIndex: nextFrameIndex;
		nextFramePosition: nextFramePosition;
		alpha: alpha;
		yourself
]

{ #category : #hooks }
WDModelAnimationChannel >> computeInterpolatedSampleForChannelPosition: channelPosition [
	^ interpolationMethod interpolateVectorSamples: outputSamples forChannelPosition: channelPosition
]

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

{ #category : #hooks }
WDModelAnimationChannel >> lowerBoundSearchPosition: position [
	| lowerIndex upperIndex bestFound |
	lowerIndex := 1.
	upperIndex := inputSamples size.
	bestFound := 1.
	
	[ lowerIndex <= upperIndex ] whileTrue: [ 
		| middleIndex middleSample |
		middleIndex := lowerIndex + ((upperIndex - lowerIndex) // 2).
		middleSample := inputSamples at: middleIndex.
		middleSample <= position ifTrue: [ 
			bestFound := middleIndex.
			lowerIndex := middleIndex + 1
		] ifFalse: [
			upperIndex := middleIndex - 1
		]
	].

	^ bestFound
	
	"| bestIndex |
	bestIndex := 1.
	self flag: 'TODO: Replace this by a binary search.'.
	inputSamples doWithIndex: [ :samplePosition :index |
		samplePosition <= position ifTrue: [ 
			bestIndex := index
		] ifFalse: [ 
			^ bestIndex
		]
	].
	
	^ inputSamples size"
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
