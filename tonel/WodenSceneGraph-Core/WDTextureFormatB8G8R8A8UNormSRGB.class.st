"
I am a texture for with channels B8 G8 R8 A8, unsigned and normalized values. The color channels are in the sRGB color space.
"
Class {
	#name : #WDTextureFormatB8G8R8A8UNormSRGB,
	#superclass : #WDTextureFormat,
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #testing }
WDTextureFormatB8G8R8A8UNormSRGB >> isB8G8R8A8UNormSRGB [
	^ true
]

{ #category : #testing }
WDTextureFormatB8G8R8A8UNormSRGB >> isSRGB [
	^ true
]
