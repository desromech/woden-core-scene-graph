"
I represent a specific tone mapping operator which is used for mapping a HDR signal into a LDR signal.
"
Class {
	#name : #WDToneMappingOperator,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #converting }
WDToneMappingOperator class >> asToneMappingOperator [
	^ self uniqueInstance
]

{ #category : #converting }
WDToneMappingOperator >> asToneMappingOperator [
	^ self
]
