"
I represent a framebuffer.
"
Class {
	#name : #WDFramebuffer,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'extent',
		'colorAttachments',
		'depthStencilAttachment',
		'swapChain',
		'uiScaleFactor'
	],
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDFramebuffer class >> forColorAttachment: aColorAttachment [
	self assert: aColorAttachment type is2DTextureType.
	^ self new
		extent: aColorAttachment width @ aColorAttachment height;
		colorAttachments: { aColorAttachment };
		yourself
]

{ #category : #'as yet unclassified' }
WDFramebuffer class >> forSwapChain: swapChain extent: extent [
	^ self new
		extent: extent;
		swapChain: swapChain;
		yourself
]

{ #category : #accessing }
WDFramebuffer >> colorAttachments [

	^ colorAttachments
]

{ #category : #accessing }
WDFramebuffer >> colorAttachments: anObject [

	colorAttachments := anObject
]

{ #category : #accessing }
WDFramebuffer >> depthStencilAttachment [

	^ depthStencilAttachment
]

{ #category : #accessing }
WDFramebuffer >> depthStencilAttachment: anObject [

	depthStencilAttachment := anObject
]

{ #category : #accessing }
WDFramebuffer >> extent [

	^ extent
]

{ #category : #accessing }
WDFramebuffer >> extent: anObject [

	extent := anObject
]

{ #category : #accessing }
WDFramebuffer >> height [
	^ extent y
]

{ #category : #initialization }
WDFramebuffer >> initialize [
	super initialize.
	extent := 0@0.
	colorAttachments := #().
	uiScaleFactor := 1.0.
	
]

{ #category : #accessing }
WDFramebuffer >> swapChain [

	^ swapChain
]

{ #category : #accessing }
WDFramebuffer >> swapChain: anObject [

	swapChain := anObject
]

{ #category : #accessing }
WDFramebuffer >> uiScaleFactor [

	^ uiScaleFactor
]

{ #category : #accessing }
WDFramebuffer >> uiScaleFactor: anObject [

	uiScaleFactor := anObject
]

{ #category : #accessing }
WDFramebuffer >> width [
	^ extent x
]
