Extension { #name : 'WDMetallicRoughnessMaterial' }

{ #category : '*WodenSceneGraph-ReadWriter' }
WDMetallicRoughnessMaterial >> asGltf2Material [
	^ WDSRWGLTF2BuilderMetallicRoughnessMaterial new
		name: name;
		emissiveFactor: { emissiveFactor x . emissiveFactor y . emissiveFactor z};
		baseColorFactor: { baseColorFactor x . baseColorFactor y . baseColorFactor z . baseColorFactor w};
		metallicFactor: metallicFactor;
		roughnessFactor: roughnessFactor;
		yourself
]
