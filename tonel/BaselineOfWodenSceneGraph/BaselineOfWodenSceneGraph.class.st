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
			package: #'WodenSceneGraph-Core';
			package: #'WodenSceneGraph-Core-Tests' with: [
				spec requires: #( #'WodenSceneGraph-Core' ).
			];
			package: #'WodenSceneGraph-AbstractGPU' with: [
				spec requires: #( #'WodenSceneGraph-AbstractGPU' ).
			]
	].

]
