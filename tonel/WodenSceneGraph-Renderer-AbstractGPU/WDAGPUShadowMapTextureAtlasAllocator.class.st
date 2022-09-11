Class {
	#name : #WDAGPUShadowMapTextureAtlasAllocator,
	#superclass : #Object,
	#instVars : [
		'atlasExtent',
		'columns',
		'rows',
		'shadowMapExtent',
		'capacity',
		'size'
	],
	#category : #'WodenSceneGraph-Renderer-AbstractGPU-Allocator'
}

{ #category : #'as yet unclassified' }
WDAGPUShadowMapTextureAtlasAllocator class >> forAtlasWithExtent: atlasExtent [
	^ self new initializeWithAtlasExtent: atlasExtent; yourself
]

{ #category : #allocation }
WDAGPUShadowMapTextureAtlasAllocator >> allocate [
	| column row offset element |
	size >= capacity ifTrue: [ ^ nil ].
	
	column := size % columns.
	row := size // columns.
	offset := (Vector2 x: column y: row) * shadowMapExtent.
	element := WDAGPUShadowMapTextureAtlasElement new
		offset: offset;
		extent: shadowMapExtent;
		atlasExtent: atlasExtent;
		yourself.
	size := size + 1.
	^ element
]

{ #category : #initialization }
WDAGPUShadowMapTextureAtlasAllocator >> initializeWithAtlasExtent: initialAtlasExtent [
	atlasExtent := initialAtlasExtent.
	columns := rows := 4.

	shadowMapExtent := Vector2 x: atlasExtent x / columns y: atlasExtent y / rows.
	capacity := columns * rows.
	size := 0.
	
]

{ #category : #allocation }
WDAGPUShadowMapTextureAtlasAllocator >> reset [
	size := 0.
]
