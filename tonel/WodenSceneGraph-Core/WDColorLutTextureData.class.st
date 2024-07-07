"
I hold a linear list of colors used as a lookup table.
"
Class {
	#name : 'WDColorLutTextureData',
	#superclass : 'Object',
	#instVars : [
		'bytes'
	],
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'instance creation' }
WDColorLutTextureData class >> with: colors [
	^ self new initializeWithColors: colors; yourself
]

{ #category : 'initialization' }
WDColorLutTextureData >> initializeWithColors: colors [
	| destIndex |
	bytes := ByteArray new: colors size * 4.
	destIndex := 1.
	colors do: [ :color |
		bytes at: destIndex put: (color blue * 255.0) rounded. destIndex := destIndex + 1.
		bytes at: destIndex put: (color green * 255.0) rounded. destIndex := destIndex + 1.
		bytes at: destIndex put: (color red * 255.0) rounded. destIndex := destIndex + 1.
		bytes at: destIndex put: (color alpha * 255.0) rounded. destIndex := destIndex + 1.
	].

]

{ #category : 'accessing' }
WDColorLutTextureData >> size [
	^ bytes size // 4
]
