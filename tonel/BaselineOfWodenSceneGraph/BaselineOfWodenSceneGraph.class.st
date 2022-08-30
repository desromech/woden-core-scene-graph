Class {
	#name : #BaselineOfWodenSceneGraph,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenSceneGraph
}

{ #category : #baselines }
BaselineOfWodenSceneGraph >> baseline: spec [
    <baseline>
	spec for: #pharo do: [ self baselineForPharo: spec ].
	spec for: #squeak do: [ self baselineForSqueak: spec ].
]

{ #category : #baselines }
BaselineOfWodenSceneGraph >> baselineForPharo: spec [
	spec postLoadDoIt: #postLoadActions.
	spec
		baseline: #'AbstractGPU' with: [ spec repository: 'github://desromech/abstract-gpu' ];
		baseline: #'WodenMath' with: [ spec repository: 'github://desromech/woden-core-math' ];
		baseline: #'FormProceduralLibrary' with: [ spec repository: 'github://desromech/form-procedural-library' ];
		baseline: #'FormSceneGraph' with: [
			spec
				repository: 'github://desromech/form-scene-graph';
				loads: #('AcceleratedAbstractGPU')
		];
	
		package: #'WodenSceneGraph-Core' with: [
			spec requires: #( #'WodenMath' #'FormSceneGraph').				
		];
		package: #'WodenSceneGraph-Core-Tests' with: [
			spec requires: #( #'WodenSceneGraph-Core' ).
		];
		package: #'WodenSceneGraph-Renderer-Core' with: [
			spec requires: #( #'WodenSceneGraph-Core').
		];
		package: #'WodenSceneGraph-Morphic' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core' #'WodenSceneGraph-Core').
		];
		package: #'WodenSceneGraph-Spec' with: [
			spec requires: #( #'WodenSceneGraph-Morphic').
		];
		package: #'WodenSceneGraph-OSWindow' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core' #'WodenSceneGraph-Core' #'AbstractGPU' #'WodenSceneGraph-Renderer-AbstractGPU').
		];
		package: #'WodenSceneGraph-Renderer-AbstractGPU' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core' #'AbstractGPU').
		];
		package: #'WodenSceneGraph-ReadWriter' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core').
		];
		package: #'WodenSceneGraph-Examples' with: [
			spec requires: #( #'WodenSceneGraph-Spec' #FormProceduralLibrary).
		]
]

{ #category : #baselines }
BaselineOfWodenSceneGraph >> baselineForSqueak: spec [
	spec
		baseline: #'AbstractGPU' with: [ spec repository: 'github://desromech/abstract-gpu' ];
		baseline: #'WodenMath' with: [ spec repository: 'github://desromech/woden-core-math' ];
		baseline: #'FormProceduralLibrary' with: [ spec repository: 'github://desromech/form-procedural-library' ];
		baseline: #'FormSceneGraph' with: [
			spec
				repository: 'github://desromech/form-scene-graph';
				loads: #('AcceleratedAbstractGPU')
		];
	
		package: #'WodenSceneGraph-Core' with: [
			spec requires: #( #'WodenMath' #'FormSceneGraph').				
		];
		package: #'WodenSceneGraph-Core-Tests' with: [
			spec requires: #( #'WodenSceneGraph-Core' ).
		];
		package: #'WodenSceneGraph-Renderer-Core' with: [
			spec requires: #( #'WodenSceneGraph-Core').
		];
		package: #'WodenSceneGraph-MorphicSqueak' with: [];
		package: #'WodenSceneGraph-Morphic' with: [
			spec requires: #( #'WodenSceneGraph-MorphicSqueak' #'WodenSceneGraph-Renderer-Core' #'WodenSceneGraph-Core').
		];
		package: #'WodenSceneGraph-Renderer-AbstractGPU' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core' #'AbstractGPU').
		];
		package: #'WodenSceneGraph-ReadWriter' with: [
			spec requires: #( #'WodenSceneGraph-Renderer-Core').
		];
		package: #'WodenSceneGraph-Examples' with: [
			spec requires: #( #FormProceduralLibrary).
		]
]

{ #category : #initialization }
BaselineOfWodenSceneGraph >> postLoadActions [
	self resetSpec2Bindings
]

{ #category : #initialization }
BaselineOfWodenSceneGraph >> resetSpec2Bindings [
	(Smalltalk at: #SpMorphicAdapterBindings ifAbsent: [ nil ]) ifNotNil: [ :cls |
		cls allInstancesDo: [ :each | each initializeBindings ]
	]
]
