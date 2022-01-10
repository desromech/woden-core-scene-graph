"
I am the description of how an object is renderer, akin to the material of a solid object.
"
Class {
	#name : #WDMaterial,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #adding }
WDMaterial >> addIntoModelAssetWithDependencies: modelAsset [
	modelAsset addMaterial: self.
]

{ #category : #'double dispatch' }
WDMaterial >> emitActivationCommandsOn: frameRenderer [
	^ false
]

{ #category : #testing }
WDMaterial >> hasAlphaBlending [
	^ false
]

{ #category : #testing }
WDMaterial >> hasDepthTesting [
	^ true
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

{ #category : #testing }
WDMaterial >> writesDepth [
	^ true
]
