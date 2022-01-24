Extension { #name : #AGPUVector3f }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
AGPUVector3f >> asVector3 [
	^ Vector3 x: self x y: self y z: self z
]
