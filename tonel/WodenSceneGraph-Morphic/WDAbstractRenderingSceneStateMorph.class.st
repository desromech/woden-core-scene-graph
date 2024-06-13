"
I am an abstract morph that connect a Woden RenderingSceneState with the Pharo UI by using the current per-session renderer.
"
Class {
	#name : 'WDAbstractRenderingSceneStateMorph',
	#superclass : 'Morph',
	#instVars : [
		'formFrameBuffer',
		'formColorBuffer',
		'sampledFrameBuffer',
		'sampledColorBuffer'
	],
	#category : 'WodenSceneGraph-Morphic',
	#package : 'WodenSceneGraph-Morphic'
}

{ #category : 'submorphs - add/remove' }
WDAbstractRenderingSceneStateMorph >> announceDeleted [
	self destroyResources.
	super announceDeleted
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> build3DSceneGraphNodeWith: builder [
	| renderingSceneState |
	renderingSceneState := self renderingSceneState.
	renderingSceneState ifNil: [ ^ builder null ].

	(builder isFormSGAGPUBuilder and: [ WDSceneRenderer current isAGPUSceneRenderer ]) ifFalse: [
		^ self buildReadbackBasedSceneGraphNodeWith: builder renderingSceneState: renderingSceneState
	].
	^ self buildAGPUBasedSceneGraphNodeWith: builder renderingSceneState: renderingSceneState

]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> buildAGPUBasedSceneGraphNodeWith: builder renderingSceneState: renderingSceneState [
	| textureHandle |
	self renderRenderingSceneStateIntoSampledFramebuffer: renderingSceneState.
	textureHandle := WDSceneRenderer current resourceCache validTextureHandleFor: sampledColorBuffer.
	^ builder agpuTextureNode
		isFullyOpaque: true;
		extent: sampledFrameBuffer extent;
		sourceRectangle: (0@0 extent: sampledFrameBuffer extent);
		texture: textureHandle;
		view: (builder createViewForTexture: textureHandle);
		rectangle: self innerBounds
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> buildReadbackBasedSceneGraphNodeWith: builder renderingSceneState: renderingSceneState [
	self renderRenderingSceneStateIntoFormFramebuffer: renderingSceneState.
	^ builder null
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> buildSceneGraphNodeWith: builder [
	^ (super buildSceneGraphNodeWith: builder) , (self build3DSceneGraphNodeWith: builder) , (self buildWindowOverlaySceneGraphNodeWith: builder)
	
]

{ #category : 'as yet unclassified' }
WDAbstractRenderingSceneStateMorph >> buildWindowOverlaySceneGraphNodeWith: builder [
	^ builder null
]

{ #category : 'accessing' }
WDAbstractRenderingSceneStateMorph >> defaultExtent [
	^ 853@480
]

{ #category : 'as yet unclassified' }
WDAbstractRenderingSceneStateMorph >> destroyResources [
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> drawOn: aCanvas [
	| renderingSceneState |
	renderingSceneState := self renderingSceneState.
	renderingSceneState ifNil: [ ^ super drawOn: aCanvas ].
	self renderRenderingSceneStateIntoFormFramebuffer: renderingSceneState.
	aCanvas drawImage: formColorBuffer data at: self bounds origin.
]

{ #category : 'scale factor' }
WDAbstractRenderingSceneStateMorph >> drawingSurfaceExtent [
	^ (self innerBounds extent * self uiScaleFactor) ceiling
]

{ #category : 'initialization' }
WDAbstractRenderingSceneStateMorph >> initialize [
	super initialize.
	self extent: self defaultExtent
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> renderRenderingSceneStateIntoFormFramebuffer: renderingSceneState [
	| drawingExtent overlaySceneGraph |
	drawingExtent := self drawingSurfaceExtent.
	overlaySceneGraph := self buildWindowOverlaySceneGraphNodeWith: (WDSceneRenderer current formSceneGraphBuilder extent: drawingExtent; yourself).
	
	(formFrameBuffer isNil or: [ formFrameBuffer extent ~= drawingExtent ]) ifTrue: [
		formColorBuffer := WDTexture forReadedColorBufferWithExtent: drawingExtent.
		formFrameBuffer := WDFramebuffer forColorAttachment: formColorBuffer.
	].
	WDSceneRenderer current renderSceneState: renderingSceneState overlay: overlaySceneGraph intoFramebuffer: formFrameBuffer.
	
]

{ #category : 'drawing' }
WDAbstractRenderingSceneStateMorph >> renderRenderingSceneStateIntoSampledFramebuffer: renderingSceneState [
	| drawingExtent |
	drawingExtent := self drawingSurfaceExtent.
	(sampledFrameBuffer isNil or: [ sampledFrameBuffer extent ~= drawingExtent ]) ifTrue: [
		sampledColorBuffer := WDTexture forSampledColorBufferWithExtent: drawingExtent.
		sampledFrameBuffer := WDFramebuffer forColorAttachment: sampledColorBuffer.
	].
	WDSceneRenderer current renderSceneState: renderingSceneState intoFramebuffer: sampledFrameBuffer.
	
]

{ #category : 'accessing' }
WDAbstractRenderingSceneStateMorph >> renderingSceneState [
	^ nil
]

{ #category : 'scale factor' }
WDAbstractRenderingSceneStateMorph >> uiScaleFactor [
	^ self worldRendererScaleFactor
]

{ #category : 'scale factor' }
WDAbstractRenderingSceneStateMorph >> worldRendererScaleFactor [
	(Smalltalk at: #FormSGAbstractWorldRenderer ifAbsent: [ ^ 1 ])
		isEnabled ifFalse: [ ^ 1 ].

	^ self world ifNil: [ 1 ]
		ifNotNil: [ :world |
			(world respondsTo: #worldState) ifTrue: [ 
				world worldState worldRenderer scaleFactor
			] ifFalse: [
				1
			]
		]
]
