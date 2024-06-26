"
I am a Woden scene renderer that uses the agpu library.
"
Class {
	#name : 'WDAGPUSceneRenderer',
	#superclass : 'WDSceneRenderer',
	#instVars : [
		'device',
		'commandQueue',
		'stateTrackerCache',
		'stateTracker',
		'resourceCache',
		'drawCommandProcessor'
	],
	#classVars : [
		'LightGridCellCount',
		'LightGridColumns',
		'LightGridRows',
		'LightGridSlices',
		'MaxClusterLightCapacity',
		'MaxLightCapacity'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenSceneGraph-Renderer-AbstractGPU-Renderer',
	#package : 'WodenSceneGraph-Renderer-AbstractGPU',
	#tag : 'Renderer'
}

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> initialize [
	MaxLightCapacity := 1024.
	MaxClusterLightCapacity := 1000.
	LightGridRows := 9.
	LightGridColumns := 16.
	LightGridSlices := 24.
	LightGridCellCount := LightGridRows*LightGridColumns*LightGridSlices
]

{ #category : 'testing' }
WDAGPUSceneRenderer class >> isAvailable [
	^ true
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> lightGridCellCount [
	^ LightGridCellCount
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> lightGridColumns [
	^ LightGridColumns
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> lightGridRows [
	^ LightGridRows
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> lightGridSlices [
	^ LightGridSlices
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> maxClusterLightCapacity [
	^ MaxClusterLightCapacity
]

{ #category : 'initialization' }
WDAGPUSceneRenderer class >> maxLightCapacity [
	^ MaxLightCapacity
]

{ #category : 'instance creation' }
WDAGPUSceneRenderer class >> new [
	^ self withResourceCache: (WDAGPUSceneRendererResourceCache for: AGPU mainDevice)
]

{ #category : 'instance creation' }
WDAGPUSceneRenderer class >> withResourceCache: aResourceCache [
	^ self basicNew initializeWithResourceCache: aResourceCache; yourself
]

{ #category : 'vr' }
WDAGPUSceneRenderer >> createVRSystem [
	| vrSystemHandle |
	vrSystemHandle := device getVRSystem.
	(vrSystemHandle isNil or: [ vrSystemHandle isNull ]) ifTrue: [ ^ nil ].
	^ WDAGPUVRSystem new
		initializeWithSceneRenderer: self handle: vrSystemHandle;
		yourself
]

{ #category : 'accessing' }
WDAGPUSceneRenderer >> device [

	^ device
]

{ #category : 'accessing' }
WDAGPUSceneRenderer >> drawCommandProcessor [
	^ drawCommandProcessor
]

{ #category : 'rendering' }
WDAGPUSceneRenderer >> formSceneGraphBuilder [
	^ WDFormSGAGPUBuilder new
		device: device;
		drawCommandProcessor: drawCommandProcessor;
		resourceCache: resourceCache;
		yourself
]

{ #category : 'initialization' }
WDAGPUSceneRenderer >> initializeWithResourceCache: aResourceCache [
	resourceCache := aResourceCache.
	device := resourceCache device.
	commandQueue := device getDefaultCommandQueue.
	stateTrackerCache := device createStateTrackerCache: commandQueue.
	stateTracker := stateTrackerCache createStateTracker: AGPU_COMMAND_LIST_TYPE_DIRECT command_queue: commandQueue.
	drawCommandProcessor := FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker forContext: resourceCache formSceneGraphDrawCommandProcessorContext withFrameBufferingCount: 1
]

{ #category : 'testing' }
WDAGPUSceneRenderer >> isAGPUSceneRenderer [
	^ true
]

{ #category : 'rendering' }
WDAGPUSceneRenderer >> readbackFramebufferAttachmentsOf: framebuffer [
	framebuffer colorAttachments do: [ :each |
		each usageMode isReadedColorAttachment ifTrue: [ 
			self readbackTextureData: each
		]
	].

	framebuffer depthStencilAttachment ifNotNil: [ :attachment |
		attachment usageMode isReadedColorAttachment ifTrue: [ 
			self readbackTextureData: attachment
		]
	]
]

{ #category : 'rendering' }
WDAGPUSceneRenderer >> readbackTextureData: texture [
	texture data ifNotNil: [ :data | data readbackDataFromAgpuTexture: (resourceCache validTextureHandleFor: texture) ]
]

{ #category : 'rendering' }
WDAGPUSceneRenderer >> renderLeftEyeSceneState: leftEyeRenderingSceneState intoFramebuffer: leftEyeFramebuffer
renderRightEyeSceneState: rightEyeRenderingSceneState intoFramebuffer: rightEyeFramebuffer
overlay: overlaySceneGraph
composeInto: destinationFramebuffer mode: composeMode [
	WDAGPUSceneRendererActiveFrameRenderer new
		renderer: self;
		recordAndFlushCommandsOn: stateTracker queue: commandQueue with: [ :frame |
			frame
				recordRenderingCommandsFor: leftEyeRenderingSceneState intoFramebuffer: leftEyeFramebuffer;
				recordRenderingCommandsFor: rightEyeRenderingSceneState intoFramebuffer: rightEyeFramebuffer;
				composeStereoLeft: leftEyeFramebuffer right: rightEyeFramebuffer into: destinationFramebuffer mode: composeMode;
				renderOverlayFormSceneGraph: overlaySceneGraph intoFramebuffer: destinationFramebuffer
		];
		finishExecution.
	self readbackFramebufferAttachmentsOf: destinationFramebuffer
]

{ #category : 'rendering' }
WDAGPUSceneRenderer >> renderSceneState: renderingSceneState overlay: overlaySceneGraph intoFramebuffer: framebuffer [
	WDAGPUSceneRendererActiveFrameRenderer new
		renderer: self;
		recordAndFlushCommandsOn: stateTracker queue: commandQueue with: [ :frame |
			frame
				recordRenderingCommandsFor: renderingSceneState intoFramebuffer: framebuffer;
				renderOverlayFormSceneGraph: overlaySceneGraph intoFramebuffer: framebuffer

		];
		finishExecution.
	self readbackFramebufferAttachmentsOf: framebuffer
]

{ #category : 'accessing' }
WDAGPUSceneRenderer >> resourceCache [

	^ resourceCache
]
