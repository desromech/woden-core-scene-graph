Class {
	#name : #WDSRWGLTF2Skin,
	#superclass : #Object,
	#instVars : [
		'name',
		'inverseBindMatrices',
		'jointIndices',
		'rootNodeIndex',
		'inverseBindMatricesAccessor',
		'skeleton',
		'jointIndexToBoneIndexPermutationTable',
		'actualBoneCount',
		'rootNode'
	],
	#pools : [
		'WDSRWGLTF2Constants'
	],
	#category : #'WodenSceneGraph-ReadWriter-GLTF2'
}

{ #category : #accessing }
WDSRWGLTF2Skin >> boneNames [

	^ boneNames
]

{ #category : #accessing }
WDSRWGLTF2Skin >> boneNames: anObject [

	boneNames := anObject
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Skin >> fetchInverseBindMatrices [
	^ inverseBindMatricesAccessor decodeContentAsArray
]

{ #category : #accessing }
WDSRWGLTF2Skin >> inverseBindMatrices [
	^ inverseBindMatrices ifNil: [ inverseBindMatrices := self fetchInverseBindMatrices ]
]

{ #category : #accessing }
WDSRWGLTF2Skin >> inverseBindMatricesAccessor [
	^ inverseBindMatricesAccessor
]

{ #category : #accessing }
WDSRWGLTF2Skin >> inverseBindMatricesAccessor: anObject [
	inverseBindMatricesAccessor := anObject
]

{ #category : #accessing }
WDSRWGLTF2Skin >> jointIndexToBoneIndexPermutationTable [
	^ jointIndexToBoneIndexPermutationTable
]

{ #category : #accessing }
WDSRWGLTF2Skin >> jointIndexToBoneIndexPermutationTable: anObject [
	jointIndexToBoneIndexPermutationTable := anObject
]

{ #category : #accessing }
WDSRWGLTF2Skin >> jointIndices [
	^ jointIndices
]

{ #category : #accessing }
WDSRWGLTF2Skin >> jointIndices: anObject [
	jointIndices := anObject
]

{ #category : #accessing }
WDSRWGLTF2Skin >> name [
	^ name
]

{ #category : #accessing }
WDSRWGLTF2Skin >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WDSRWGLTF2Skin >> permutatedInverseBindMatrices [
	| permutatedMatrices |
	permutatedMatrices := Array new: skeleton bones size.
	permutatedMatrices atAllPut: Matrix4x4 identity.
	self inverseBindMatrices doWithIndex: [ :each :index |
		permutatedMatrices at: (jointIndexToBoneIndexPermutationTable at: index) + 1 put: each
	].
	^ permutatedMatrices
]

{ #category : #accessing }
WDSRWGLTF2Skin >> rootNode [

	^ rootNode
]

{ #category : #accessing }
WDSRWGLTF2Skin >> rootNode: anObject [

	rootNode := anObject
]

{ #category : #accessing }
WDSRWGLTF2Skin >> rootNodeIndex [
	^ rootNodeIndex
]

{ #category : #accessing }
WDSRWGLTF2Skin >> rootNodeIndex: anObject [
	rootNodeIndex := anObject
]

{ #category : #accessing }
WDSRWGLTF2Skin >> skeleton [
	^ skeleton ifNil: [ skeleton := WDSkeleton new name: name ]
]
