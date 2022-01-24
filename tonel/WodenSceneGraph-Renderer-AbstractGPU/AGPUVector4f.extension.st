Extension { #name : #AGPUVector4f }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
AGPUVector4f >> asVector4 [
	^ Vector4 x: self x y: self y z: self z w: self w
]
