"
I am the description of how an object is renderer, akin to the material of a solid object.
"
Class {
	#name : #WDMaterial,
	#superclass : #Object,
	#category : #'WodenSceneGraph-Core-Material'
}

{ #category : #'double dispatch' }
WDMaterial >> emitActivationCommandsOn: frameRenderer [
	^ false
]
