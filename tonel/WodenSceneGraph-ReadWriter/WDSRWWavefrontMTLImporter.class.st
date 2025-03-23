"
I am an importer for wavefront obj .mtl material library files.
"
Class {
	#name : 'WDSRWWavefrontMTLImporter',
	#superclass : 'Object',
	#instVars : [
		'currentDirectory',
		'currentMaterial',
		'materialLibrary'
	],
	#classVars : [
		'CommandDictionary'
	],
	#category : 'WodenSceneGraph-ReadWriter-OBJ',
	#package : 'WodenSceneGraph-ReadWriter',
	#tag : 'OBJ'
}

{ #category : 'initialization' }
WDSRWWavefrontMTLImporter class >> initialize [
	super initialize.
	CommandDictionary := Dictionary newFromPairs: {
		#newmtl . [ :myself :arguments | myself beginMaterial: arguments second ].
		#Ka . [ :myself :arguments | myself parseAmbientColor: arguments ].
		#map_Ka . [ :myself :arguments | myself parseAmbientMap: arguments second ].
		
		#Kd . [ :myself :arguments | myself parseDiffuseColor: arguments ].
		#map_Kd . [ :myself :arguments | myself parseDiffuseMap: arguments second ].
		
		#Ks . [ :myself :arguments | myself parseSpecularColor: arguments ].
		#map_Ks . [ :myself :arguments | myself parseSpecularMap: arguments second].
		
		#illum . [ :myself :arguments | myself parseIlluminationMode: arguments second ].
	}
]

{ #category : 'initialization' }
WDSRWWavefrontMTLImporter class >> loadFromFile: aFileName [
	^ self new loadFromFile: aFileName
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontMTLImporter >> beginMaterial: materialName [
	currentMaterial := WDMetallicRoughnessMaterial new.
	materialLibrary at: materialName put: currentMaterial
]

{ #category : 'as yet unclassified' }
WDSRWWavefrontMTLImporter >> loadFromFile: aFileName [
	| fileRef |
	fileRef := aFileName asFileReference.
	currentDirectory := fileRef parent.
	^ fileRef readStreamDo: [ :fin |
		self parseLinesWith: (WDSRWLineReader on: fin)
	]
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseAmbientColor: parameters [
	"Ignored"
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseAmbientMap: textureName [
	"Ignored"
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseDiffuseColor: parameters [
	| r g b color |
	currentMaterial ifNil: [ ^ self ].
	r := parameters second asNumber.
	g := parameters third asNumber.
	b := parameters fourth asNumber.
	color := Vector4 x: r y: g z: b w: currentMaterial baseColorFactor w.
	currentMaterial baseColorFactor: color
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseDiffuseMap: textureName [
	currentMaterial baseColorTexture: (WDTexture forColorFileReference: (currentDirectory resolve: textureName))
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseIlluminationMode: parameters [
	"Ignored"
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseLine: line [
	| components command |
	line ifEmpty: [ ^ self ].
	line first = $# ifTrue: [ ^ self ].
	
	components := line substrings.
	command := components first.
	(CommandDictionary at: command ifAbsent: [ ^ self ]) value: self value: components
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseLinesWith: lineReader [
	materialLibrary := Dictionary new.
	[lineReader atEnd] whileFalse: [ 
		self parseLine: lineReader nextLine
	].

	^ materialLibrary
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseSpecularColor: parameters [
	"Ignored because of PBR"
]

{ #category : 'parsing' }
WDSRWWavefrontMTLImporter >> parseSpecularMap: textureName [
	"Ignored because of PBR"
]
