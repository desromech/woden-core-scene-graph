Extension { #name : #AGPUVector2f }

{ #category : #'*WodenSceneGraph-Renderer-AbstractGPU' }
AGPUVector2f >> asVector2 [
	^ Vector2 x: self x y: self y
]
