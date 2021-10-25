Class {
	#name : #WDBinaryBufferAccessorMatrix4x4Type,
	#superclass : #WDBinaryBufferAccessorType,
	#category : #'WodenSceneGraph-Core-Resources'
}

{ #category : #accessing }
WDBinaryBufferAccessorMatrix4x4Type >> componentCount [
	^ 16
]

{ #category : #factory }
WDBinaryBufferAccessorMatrix4x4Type >> makeWithComponents: components [
	^ Matrix4x4 basicNew
		m11: (components at: 1); m21: (components at: 2); m31: (components at: 3); m41: (components at: 4);
		m12: (components at: 5); m22: (components at: 6); m32: (components at: 7); m42: (components at: 8);
		m13: (components at: 9); m23: (components at: 10); m33: (components at: 11); m43: (components at: 12);
		m14: (components at: 13); m24: (components at: 14); m34: (components at: 15); m44: (components at: 16);
		yourself
]
