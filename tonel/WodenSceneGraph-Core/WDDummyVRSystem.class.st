"
I am a dummy VR system. I am used for testing the VR rendering interface, and to provide generic stereo monitor support.
"
Class {
	#name : #WDDummyVRSystem,
	#superclass : #WDVRSystem,
	#instVars : [
		'ipd',
		'focalDistance'
	],
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #initialization }
WDDummyVRSystem >> initialize [
	super initialize.
	ipd := 0.065.
	focalDistance := 1.0.
	
]

{ #category : #testing }
WDDummyVRSystem >> isDummyVRSystem [
	^ true
]

{ #category : #'as yet unclassified' }
WDDummyVRSystem >> leftEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ FrustumTangents leftPerspectiveFovY: cameraFovY aspect: displayAspectRatio ipd: ipd focalDistance: focalDistance
]

{ #category : #projection }
WDDummyVRSystem >> leftEyeLocalTransform [
	^ ReversibleAffineTransform3D translation: (Vector3 x: ipd * -0.5)
]

{ #category : #'as yet unclassified' }
WDDummyVRSystem >> rightEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ FrustumTangents rightPerspectiveFovY: cameraFovY aspect: displayAspectRatio ipd: ipd focalDistance: focalDistance
]

{ #category : #projection }
WDDummyVRSystem >> rightEyeLocalTransform [
	^ ReversibleAffineTransform3D translation: (Vector3 x: ipd * 0.5)
]
