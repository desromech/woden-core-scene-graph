Extension { #name : 'WDUnlitMaterial' }

{ #category : '*WodenSceneGraph-ReadWriter' }
WDUnlitMaterial >> asGltf2Material [
	^ WDSRWGLTF2BuilderUnlitMaterial new
		name: name;
		colorFactor: { colorFactor x . colorFactor y. colorFactor z. colorFactor w};
		yourself
]
