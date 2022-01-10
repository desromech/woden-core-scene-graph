Extension { #name : #SpAbstractMorphicAdapter }

{ #category : #'*WodenSceneGraph-Spec' }
SpAbstractMorphicAdapter >> installMouseWheelEvent: anEvent to: aWidget [
	aWidget 
		on: #mouseWheel
		send: #value:
		to: anEvent action
]
