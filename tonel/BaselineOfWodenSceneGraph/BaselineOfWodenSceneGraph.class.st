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
		
			package: #'WodenSceneGraph-Core' with: [
				spec requires: #( #'WodenMath' ).				
			];
			package: #'WodenSceneGraph-Tests' with: [
				spec requires: #( #'WodenSceneGraph-Core' ).
			];
			package: #'WodenSceneGraph-AbstractGPU' with: [
				spec requires: #( #'WodenSceneGraph-Core' #'AbstractGPU').
			]
	].

]
