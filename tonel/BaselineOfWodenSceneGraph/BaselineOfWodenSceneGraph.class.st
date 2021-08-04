Class {
	#name : #BaselineOfWodenSceneGraph,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenSceneGraph
}

{ #category : #baselines }
BaselineOfWodenSceneGraph >> baseline: spec [
    <baseline>
	spec for: #'common' do: [
		spec
			baseline: #'AbstractGPU' with: [ spec repository: 'github://ronsaldo/abstract-gpu' ];
			baseline: #'WodenMath' with: [ spec repository: 'github://ronsaldo/woden-core-math' ];
			baseline: #'FormSceneGraph' with: [
				spec
					repository: 'github://ronsaldo/form-scene-graph';
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
			package: #'WodenSceneGraph-Renderer-AbstractGPU' with: [
				spec requires: #( #'WodenSceneGraph-Renderer-Core' #'AbstractGPU').
			]
	].

]
