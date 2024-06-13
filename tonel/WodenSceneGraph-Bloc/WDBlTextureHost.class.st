"
I am Bloc host whose render space is a Woden texture.
"
Class {
	#name : 'WDBlTextureHost',
	#superclass : 'BlHost',
	#instVars : [
		'texture'
	],
	#classVars : [
		'PulseLoop'
	],
	#category : 'WodenSceneGraph-Bloc',
	#package : 'WodenSceneGraph-Bloc'
}

{ #category : 'geometry' }
WDBlTextureHost class >> extent: anExtent [
	^ self new initializeWithExtent: anExtent; yourself
]

{ #category : 'api - lifecycle' }
WDBlTextureHost class >> initialize [
	PulseLoop := BlHostPulseLoop forHost: self
]

{ #category : 'api - lifecycle' }
WDBlTextureHost class >> isRunning [
	^ PulseLoop isRunning
]

{ #category : 'driver selection' }
WDBlTextureHost class >> label [
	^ 'Woden Texture Host'
]

{ #category : 'api - lifecycle' }
WDBlTextureHost class >> pulsePeriod: aDuration [

	PulseLoop pulsePeriod: aDuration
]

{ #category : 'api - lifecycle' }
WDBlTextureHost class >> start [
	PulseLoop start
]

{ #category : 'api - lifecycle' }
WDBlTextureHost class >> stop [
	PulseLoop stop
]

{ #category : 'api - ui process' }
WDBlTextureHost class >> uiProcessDo: aBlock [
	"Evaluate aBlock with the running UI Process of this host if any"
	
	PulseLoop loopProcess ifNotNil: aBlock
]

{ #category : 'private' }
WDBlTextureHost >> createHostSpace [
	^ WDBlTextureHostSpace new
]

{ #category : 'host - api' }
WDBlTextureHost >> createHostSpaceFor: aSpace [
	"Create and assign a new host space for given bloc space"

	| aHostSpace|
	aHostSpace := self createTextureSpaceFor: aSpace.
	aHostSpace renderer: BlHostRenderer preferableClass new.

	aSpace hostSpace: aHostSpace
]

{ #category : 'host - api' }
WDBlTextureHost >> createTextureSpaceFor: aSpace [
	| aHostSpace |
	aHostSpace := self createHostSpace.
	aHostSpace
		texture: texture;
		universe: self universe;
		host: self;
		space: aSpace.
	
	^ aHostSpace
]

{ #category : 'host - api' }
WDBlTextureHost >> destroyHostSpaceFor: aSpace [
	"Closes OSWindow window and unrefer it from bloc space"
	
	aSpace hostSpace
		close;
		detachSpace;
		detachHost;
		detachUniverse.

	aSpace detachHostSpace
]

{ #category : 'initialization' }
WDBlTextureHost >> initializeWithExtent: anExtent [
	texture := WDTexture forColorForm: (Form extent: anExtent depth: 32).
]

{ #category : 'accessing' }
WDBlTextureHost >> texture [
	^ texture
]

{ #category : 'accessing' }
WDBlTextureHost >> texture: anObject [

	texture := anObject
]
