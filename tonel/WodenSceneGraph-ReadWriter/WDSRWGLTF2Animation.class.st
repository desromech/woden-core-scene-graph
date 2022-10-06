Class {
	#name : #WDSRWGLTF2Animation,
	#superclass : #Object,
	#instVars : [
		'samplers',
		'channels',
		'name'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #converting }
WDSRWGLTF2Animation >> asModelAnimation [
	^ WDModelAnimation new
		name: name;
		channels: (channels collect: [ :each | each asModelAnimationChannel ]);
		yourself
]

{ #category : #accessing }
WDSRWGLTF2Animation >> channels [
	^ channels
]

{ #category : #accessing }
WDSRWGLTF2Animation >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDSRWGLTF2Animation >> name [
	^ name
]

{ #category : #accessing }
WDSRWGLTF2Animation >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDSRWGLTF2Animation >> samplers [
	^ samplers
]

{ #category : #accessing }
WDSRWGLTF2Animation >> samplers: anObject [
	samplers := anObject
]
