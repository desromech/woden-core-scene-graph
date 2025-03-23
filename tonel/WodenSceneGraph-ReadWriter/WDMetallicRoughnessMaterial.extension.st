Extension { #name : 'WDMetallicRoughnessMaterial' }

{ #category : '*WodenSceneGraph-ReadWriter' }
WDMetallicRoughnessMaterial >> asGltf2MaterialWithBuilder: builder [
	^ WDSRWGLTF2BuilderMetallicRoughnessMaterial new
		name: name;
		normalTexture: (builder convertTexture: normalTexture);
		occlusionTexture: (builder convertTexture: occlusionTexture);
		emissiveFactor: { emissiveFactor x . emissiveFactor y . emissiveFactor z};
		emissiveTexture: (builder convertTexture: emissiveTexture );

		baseColorFactor: { baseColorFactor x . baseColorFactor y . baseColorFactor z . baseColorFactor w};
		baseColorTexture: (builder convertTexture: baseColorTexture );
		metallicFactor: metallicFactor;
		roughnessFactor: roughnessFactor;
		metallicRoughnessTexture: (builder convertTexture: metallicRoughnessTexture );
		yourself
]
