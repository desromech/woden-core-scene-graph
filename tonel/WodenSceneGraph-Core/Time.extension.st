Extension { #name : #Time }

{ #category : #'*WodenSceneGraph-Core' }
Time class >> monotonicMicrosecondClockValue [
	"A proper primitive here should be added for this."
	<primitive: 240>
	^ self millisecondClockValue * 1000
]
