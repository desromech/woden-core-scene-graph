Class {
	#name : #WDSRWGLTF2SkeletonGraphNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'bone'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDSRWGLTF2SkeletonGraphNode >> bone [

	^ bone
]

{ #category : #accessing }
WDSRWGLTF2SkeletonGraphNode >> bone: anObject [

	bone := anObject
]

{ #category : #accessing }
WDSRWGLTF2SkeletonGraphNode >> parent [

	^ parent
]

{ #category : #accessing }
WDSRWGLTF2SkeletonGraphNode >> parent: anObject [

	parent := anObject
]
