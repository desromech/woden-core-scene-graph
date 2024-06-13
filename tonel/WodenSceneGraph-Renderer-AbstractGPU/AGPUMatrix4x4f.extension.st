Extension { #name : 'AGPUMatrix4x4f' }

{ #category : '*WodenSceneGraph-Renderer-AbstractGPU' }
AGPUMatrix4x4f >> asReversibleAffineTransform3D [
	| matrix translation |
	matrix := Matrix3x3 columns: {
		self c1 asVector3.
		self c2 asVector3.
		self c3 asVector3
	}.
	translation := self c4 asVector3.
	^ ReversibleAffineTransform3D orthonormal: matrix translation: translation
]
