"
I represent a specific virtual reality system.
"
Class {
	#name : #WDVRSystem,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-VR'
}

{ #category : #head }
WDVRSystem >> headTransform [
	^ ReversibleAffineTransform3D identity 
]

{ #category : #testing }
WDVRSystem >> isDummyVRSystem [
	^ false
]

{ #category : #eyes }
WDVRSystem >> leftEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> leftEyeTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'vr system' }
WDVRSystem >> pollEvents [
]

{ #category : #eyes }
WDVRSystem >> rightEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> rightEyeTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'vr system' }
WDVRSystem >> submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeTexture rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeTexture [
]

{ #category : #'vr system' }
WDVRSystem >> waitAndFetchPoses [
]
