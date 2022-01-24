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

{ #category : #testing }
WDVRSystem >> isRealVRSystem [
	^ false
]

{ #category : #eyes }
WDVRSystem >> leftEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> leftEyeLocalTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'as yet unclassified' }
WDVRSystem >> leftEyeTransform [
	^ self headTransform transformTransform: self leftEyeLocalTransform
]

{ #category : #'as yet unclassified' }
WDVRSystem >> perEyeFrameBufferExtentForDisplayWithExtent: displayExtent [
	^ displayExtent
]

{ #category : #'vr system' }
WDVRSystem >> pollEvents [
]

{ #category : #eyes }
WDVRSystem >> rightEyeFrustumTangentsWithFovY: cameraFovY aspect: displayAspectRatio [
	^ self subclassResponsibility
]

{ #category : #projection }
WDVRSystem >> rightEyeLocalTransform [
	^ ReversibleAffineTransform3D identity
]

{ #category : #'as yet unclassified' }
WDVRSystem >> rightEyeTransform [
	^ self headTransform transformTransform: self rightEyeLocalTransform
]

{ #category : #'vr system' }
WDVRSystem >> submitLeftEyeFramebuffer: leftEyeFramebuffer texture: leftEyeTexture rightEyeFramebuffer: rightEyeFramebuffer texture: rightEyeTexture [
]

{ #category : #'vr system' }
WDVRSystem >> waitAndFetchPoses [
]
