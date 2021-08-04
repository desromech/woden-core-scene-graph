"
I represent a framebuffer.
"
Class {
	#name : #WDFramebuffer,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'extent',
		'colorAttachments',
		'depthStencilAttachment'
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

{ #category : #initialization }
WDFramebuffer >> initialize [
	super initialize.
	extent := 0@0.
	colorAttachments := #().
]
