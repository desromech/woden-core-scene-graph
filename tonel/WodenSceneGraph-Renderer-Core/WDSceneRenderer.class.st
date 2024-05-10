"
I am the interface for a scene renderer.
"
Class {
	#name : #WDSceneRenderer,
	#superclass : #Object,
	#classVars : [
		'BloomEnabled',
		'Current',
		'CurrentSession',
		'ScreenSpaceAmbientOcclusionEnabled',
		'ScreenSpaceReflectionEnabled',
		'ShadowMappingEnabled'
	],
	#category : #'WodenSceneGraph-Renderer-Core'
}

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> bloomEnabled [
	^ BloomEnabled ifNil: [ BloomEnabled := true ]
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> bloomEnabled: aBoolean [
	^ BloomEnabled := aBoolean
]

{ #category : #accessing }
WDSceneRenderer class >> current [
	(Current isNil or: [CurrentSession ~~ Smalltalk session]) ifTrue: [ 
		Current := self pick new.
		CurrentSession := Smalltalk session
	].
	^ Current
]

{ #category : #testing }
WDSceneRenderer class >> isAbstract [
	^ self == WDSceneRenderer
]

{ #category : #testing }
WDSceneRenderer class >> isAvailable [
	^ false
]

{ #category : #'instance creation' }
WDSceneRenderer class >> newStandalone [
	^ self pick new
]

{ #category : #private }
WDSceneRenderer class >> pick [
	self allSubclassesDo: [ :each |
		each isAvailable ifTrue: [ ^ each ]
	].
	^ WDNullSceneRenderer
]

{ #category : #initialization }
WDSceneRenderer class >> reset [
	<script>
	Current := nil
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> screenSpaceAmbientOcclusionEnabled [
	^ ScreenSpaceAmbientOcclusionEnabled ifNil: [ ScreenSpaceAmbientOcclusionEnabled := true ]
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> screenSpaceAmbientOcclusionEnabled: aBoolean [
	^ ScreenSpaceAmbientOcclusionEnabled := aBoolean
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> screenSpaceReflectionEnabled [
	^ ScreenSpaceReflectionEnabled ifNil: [ ScreenSpaceReflectionEnabled := true ]
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> screenSpaceReflectionEnabled: aBoolean [
	^ ScreenSpaceReflectionEnabled := aBoolean
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> shadowMappingEnabled [
	^ ShadowMappingEnabled ifNil: [ ShadowMappingEnabled := true ]
]

{ #category : #'as yet unclassified' }
WDSceneRenderer class >> shadowMappingEnabled: aBoolean [
	^ ShadowMappingEnabled := aBoolean
]

{ #category : #preferences }
WDSceneRenderer class >> wodenSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #woden)
		label: 'Woden';
		description: 'Woden Settings';
		with: [
			(aBuilder setting: #shadowMappingEnabled)
				label: 'Shadow Mapping Enabled';
				description: 'This enables the support for shadow mapping.'.
			(aBuilder setting: #screenSpaceAmbientOcclusionEnabled)
				label: 'SSAO Enabled';
				description: 'This enables the support for screen space ambient occlusion.'.
			(aBuilder setting: #screenSpaceReflectionEnabled)
				label: 'SSR Enabled';
				description: 'This enables the support for screen space reflection.'.
			(aBuilder setting: #bloomEnabled)
				label: 'Bloom Enabled';
				description: 'This enables the support for bloom.'.
		]
]

{ #category : #'as yet unclassified' }
WDSceneRenderer >> bloomEnabled [
	^ self class bloomEnabled
]

{ #category : #vr }
WDSceneRenderer >> createVRSystem [
	^ nil
]

{ #category : #rendering }
WDSceneRenderer >> formSceneGraphBuilder [
	^ FormSGBuilder new
]

{ #category : #testing }
WDSceneRenderer >> isAGPUSceneRenderer [
	^ false
]

{ #category : #testing }
WDSceneRenderer >> isNullSceneRenderer [
	^ false
]

{ #category : #rendering }
WDSceneRenderer >> renderSceneState: renderingSceneState intoFramebuffer: framebuffer [
	^ self renderSceneState: renderingSceneState overlay: nil intoFramebuffer: framebuffer
]

{ #category : #rendering }
WDSceneRenderer >> renderSceneState: renderingSceneState overlay: overlaySceneGraph intoFramebuffer: framebuffer [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDSceneRenderer >> screenSpaceAmbientOcclusionEnabled [
	^ self class screenSpaceAmbientOcclusionEnabled
]

{ #category : #'as yet unclassified' }
WDSceneRenderer >> screenSpaceReflectionEnabled [
	^ self class screenSpaceReflectionEnabled
]

{ #category : #'as yet unclassified' }
WDSceneRenderer >> shadowMappingEnabled [
	^ self class shadowMappingEnabled
]
