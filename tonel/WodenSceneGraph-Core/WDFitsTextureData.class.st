"
I hold texture data which is read from a fits texture.
"
Class {
	#name : #WDFitsTextureData,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'depth',
		'pitch',
		'slicePitch',
		'bytes'
	],
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #accessing }
WDFitsTextureData >> bytes [

	^ bytes
]

{ #category : #accessing }
WDFitsTextureData >> bytes: anObject [

	bytes := anObject
]

{ #category : #accessing }
WDFitsTextureData >> depth [

	^ depth
]

{ #category : #accessing }
WDFitsTextureData >> depth: anObject [

	depth := anObject
]

{ #category : #accessing }
WDFitsTextureData >> height [

	^ height
]

{ #category : #accessing }
WDFitsTextureData >> height: anObject [

	height := anObject
]

{ #category : #accessing }
WDFitsTextureData >> pitch [

	^ pitch
]

{ #category : #accessing }
WDFitsTextureData >> pitch: anObject [

	pitch := anObject
]

{ #category : #accessing }
WDFitsTextureData >> slicePitch [

	^ slicePitch
]

{ #category : #accessing }
WDFitsTextureData >> slicePitch: anObject [

	slicePitch := anObject
]

{ #category : #accessing }
WDFitsTextureData >> width [

	^ width
]

{ #category : #accessing }
WDFitsTextureData >> width: anObject [

	width := anObject
]
