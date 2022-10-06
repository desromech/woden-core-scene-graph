Class {
	#name : #WDSRWGLTF2AnimationSampler,
	#superclass : #Object,
	#instVars : [
		'inputAccessor',
		'outputAccessor',
		'interpolationAlgorithm'
	],
	#classVars : [
		'InterpolationAlgorithmToInterpolationMethodMap'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #'class initialization' }
WDSRWGLTF2AnimationSampler class >> initialize [
	InterpolationAlgorithmToInterpolationMethodMap := Dictionary newFromPairs: { 
		'LINEAR' . WDCurveInterpolationMethodLinear asCurveInterpolationMethod.
		'STEP' . WDCurveInterpolationMethodStep asCurveInterpolationMethod.
		'CUBICSPLINE' . WDCurveInterpolationMethodCubicSpline asCurveInterpolationMethod.
	}

]

{ #category : #'as yet unclassified' }
WDSRWGLTF2AnimationSampler >> animationInterpolationMethod [
	^ InterpolationAlgorithmToInterpolationMethodMap at: interpolationAlgorithm ifAbsent: [ WDCurveInterpolationMethodStep uniqueInstance ]
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> inputAccessor [
	^ inputAccessor
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> inputAccessor: anObject [
	inputAccessor := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> inputMaxValue [
	^ inputAccessor max
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> inputMinValue [
	^ inputAccessor min
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> inputValues [
	^ inputAccessor decodeContentAsArray
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> interpolationAlgorithm [
	^ interpolationAlgorithm
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> interpolationAlgorithm: anObject [
	interpolationAlgorithm := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> outputAccessor [
	^ outputAccessor
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> outputAccessor: anObject [
	outputAccessor := anObject
]

{ #category : #accessing }
WDSRWGLTF2AnimationSampler >> outputValues [
	^ outputAccessor decodeContentAsArray
]
