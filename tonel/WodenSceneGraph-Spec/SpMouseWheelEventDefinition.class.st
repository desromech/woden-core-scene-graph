Class {
	#name : #SpMouseWheelEventDefinition,
	#superclass : #SpBaseEventDefinition,
	#category : #'WodenSceneGraph-Spec'
}

{ #category : #installing }
SpMouseWheelEventDefinition >> installOn: anAdapter target: aWidget [

	anAdapter installMouseWheelEvent: self to: aWidget
]
