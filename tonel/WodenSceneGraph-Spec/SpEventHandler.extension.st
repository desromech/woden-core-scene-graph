Extension { #name : 'SpEventHandler' }

{ #category : '*WodenSceneGraph-Spec' }
SpEventHandler >> whenMouseWheelDo: aBlock [
	"register a mouse move event. 
	 aBlock receives 'event' as parameter"

	 self register: (SpMouseWheelEventDefinition do: aBlock)
]
