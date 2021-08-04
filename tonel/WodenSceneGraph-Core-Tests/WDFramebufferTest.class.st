"
A WDFramebufferTest is a test class for testing the behavior of WDFramebuffer
"
Class {
	#name : #WDFramebufferTest,
	#superclass : #TestCase,
	#category : #'WodenSceneGraph-Core-Tests-Texture'
}

{ #category : #tests }
WDFramebufferTest >> testForColorAttachment [
	| colorBuffer framebuffer |
	colorBuffer := WDTexture forReadedColorBufferWithExtent: 16@16.
	framebuffer := WDFramebuffer forColorAttachment: colorBuffer.
	self assert: framebuffer extent equals: 16@16.
	self assert: framebuffer colorAttachments first equals: colorBuffer.
	self assert: framebuffer depthStencilAttachment isNil.
]

{ #category : #tests }
WDFramebufferTest >> testNew [
	| framebuffer |
	framebuffer := WDFramebuffer new.
	self assert: framebuffer extent equals: 0@0.
	self assert: framebuffer colorAttachments isEmpty.
	self assert: framebuffer depthStencilAttachment isNil.
]
