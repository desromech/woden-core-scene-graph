Extension { #name : 'WDUnlitMaterial' }

{ #category : '*WodenSceneGraph-ReadWriter' }
WDUnlitMaterial >> asGltf2MaterialWithBuilder: builder [
	^ WDSRWGLTF2BuilderUnlitMaterial new
		name: name;
		colorFactor: { colorFactor x . colorFactor y. colorFactor z. colorFactor w};
		colorTexture: (builder convertTexture: colorTexture );
		yourself
]
