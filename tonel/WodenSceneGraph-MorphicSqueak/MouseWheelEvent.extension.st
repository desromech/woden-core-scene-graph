Extension { #name : #MouseWheelEvent }

{ #category : #'*WodenSceneGraph-MorphicSqueak' }
MouseWheelEvent >> isDown [
	^ self isWheelDown
]

{ #category : #'*WodenSceneGraph-MorphicSqueak' }
MouseWheelEvent >> isLeft [
	^ self isWheelLeft
]

{ #category : #'*WodenSceneGraph-MorphicSqueak' }
MouseWheelEvent >> isRight [
	^ self isWheelRight
]

{ #category : #'*WodenSceneGraph-MorphicSqueak' }
MouseWheelEvent >> isUp [
	^ self isWheelUp
]
