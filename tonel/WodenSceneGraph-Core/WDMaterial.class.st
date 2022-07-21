"
I am the description of how an object is renderer, akin to the material of a solid object.
"
Class {
	#name : #WDMaterial,
	#superclass : #Object,
	#instVars : [
		'name',
		'materialDirectory'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #'as yet unclassified' }
WDMaterial class >> getClassForTypeName: expectedTypeName [
	self allSubclassesDo: [ :each |
		(each isAbstract not and: [ each typeName = expectedTypeName ]) ifTrue: [ ^ each ]
	].
	^ nil
]

{ #category : #testing }
WDMaterial class >> isAbstract [
	^ self == WDMaterial
]

{ #category : #serialization }
WDMaterial class >> loadFromFileNamed: aFileName [
	^ self loadFromFileReference: aFileName asFileReference
	
]

{ #category : #serialization }
WDMaterial class >> loadFromFileReference: aFileReference [
	| jsonData |
	jsonData := STONJSON fromString: aFileReference contents.
	^ self loadFromJson: jsonData inDirectory: aFileReference parent
	
]

{ #category : #serialization }
WDMaterial class >> loadFromJson: jsonData [
	^ self loadFromJson: jsonData inDirectory: FileSystem workingDirectory
	
]

{ #category : #serialization }
WDMaterial class >> loadFromJson: jsonData inDirectory: materialDirectory [
	^ (self getClassForTypeName: (jsonData at: #type))
		ifNil: [ nil ]
		ifNotNil: [ :cls | cls new loadFromJson: jsonData inDirectory: materialDirectory ]
		
]

{ #category : #accessing }
WDMaterial class >> typeName [
	self subclassResponsibility
]

{ #category : #adding }
WDMaterial >> addIntoModelAssetWithDependencies: modelAsset [
	modelAsset addMaterial: self.
]

{ #category : #converting }
WDMaterial >> asUnlitMaterial [
	^ self
]

{ #category : #'double dispatch' }
WDMaterial >> emitActivationCommandsOn: frameRenderer [
	^ false
]

{ #category : #serialization }
WDMaterial >> encodeJsonKeyValues [
	^ {
		#type . self typeName.
		#name . name.
	}
]

{ #category : #testing }
WDMaterial >> hasAlphaBlending [
	^ false
]

{ #category : #testing }
WDMaterial >> hasDepthTesting [
	^ true
]

{ #category : #serialization }
WDMaterial >> loadFromJson: jsonData [
	name := jsonData at: #name ifAbsent: [ name ].
]

{ #category : #serialization }
WDMaterial >> loadFromJson: jsonData inDirectory: theMaterialDirectory [
	materialDirectory := theMaterialDirectory.
	self loadFromJson: jsonData
]

{ #category : #'as yet unclassified' }
WDMaterial >> makeThumbnail [
	^ nil
]

{ #category : #accessing }
WDMaterial >> name [

	^ name
]

{ #category : #accessing }
WDMaterial >> name: anObject [

	name := anObject
]

{ #category : #rendering }
WDMaterial >> renderPriority [
	^ WDRenderPriority default
]

{ #category : #accessing }
WDMaterial >> typeName [
	^ self class typeName
]

{ #category : #testing }
WDMaterial >> writesDepth [
	^ true
]
