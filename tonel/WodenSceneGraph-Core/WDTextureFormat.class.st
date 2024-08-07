"
I represent a specific texture format.
"
Class {
	#name : 'WDTextureFormat',
	#superclass : 'WDAbstractEnumClass',
	#category : 'WodenSceneGraph-Core-Texture',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Texture'
}

{ #category : 'converting' }
WDTextureFormat class >> asTextureFormat [
	^ self uniqueInstance
]

{ #category : 'converting' }
WDTextureFormat >> asTextureFormat [
	^ self
]

{ #category : 'testing' }
WDTextureFormat >> hasDepthComponent [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> hasStencilComponent [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isB8G8R8A8UNorm [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isB8G8R8A8UNormSRGB [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR16G16B16A16Float [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR16SNorm [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR16UNorm [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR32Float [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR8G8B8A8UNorm [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR8G8B8A8UNormSRGB [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isR8UNorm [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isSRGB [
	^ false
]

{ #category : 'testing' }
WDTextureFormat >> isUnknown [
	^ false
]
