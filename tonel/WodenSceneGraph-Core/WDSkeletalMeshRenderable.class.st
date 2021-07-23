"
I am a renderable that holds a mesh with skeletal animation deformation data.
"
Class {
	#name : #WDSkeletalMeshRenderable,
	#superclass : #WDRenderable,
	#instVars : [
		'referenceMesh',
		'skeleton',
		'currentPose'
	],
	#category : #'WodenSceneGraph-Core-Renderable'
}
