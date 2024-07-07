"
I am a resource whose data might need to be cached by a specific renderer implementation. This tracking is performed by keeping track of a modification count.

The modification count is not required to be monotone. It is only required to be different, so we keep only 31 bits to ensure this is always a SmallInteger.
"
Class {
	#name : 'WDRendererCacheableResource',
	#superclass : 'Object',
	#instVars : [
		'modificationCount'
	],
	#category : 'WodenSceneGraph-Core-Resources',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Resources'
}

{ #category : 'updating' }
WDRendererCacheableResource >> changed [
	"31 bits are more than enough. The renderer only cares about different values here."
	modificationCount := (modificationCount + 1) bitAnd: 16r7FFFFFFF
]

{ #category : 'initialization' }
WDRendererCacheableResource >> initialize [
	super initialize.
	modificationCount := 0.
]

{ #category : 'accessing' }
WDRendererCacheableResource >> modificationCount [

	^ modificationCount
]
