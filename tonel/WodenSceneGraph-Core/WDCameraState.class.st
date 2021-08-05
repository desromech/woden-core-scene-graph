"
I encapsulate the rendering state for a camera.
"
Class {
	#name : #WDCameraState,
	#superclass : #WDRenderingObjectState,
	#instVars : [
		'projectionMatrix',
		'frustum',
		'nearDistance',
		'farDistance',
		'currentTime',
		'exposure'
	],
	#category : #'WodenSceneGraph-Core-RenderingState'
}

{ #category : #accessing }
WDCameraState >> currentTime [

	^ currentTime
]

{ #category : #accessing }
WDCameraState >> currentTime: anObject [

	currentTime := anObject
]

{ #category : #accessing }
WDCameraState >> exposure [

	^ exposure
]

{ #category : #accessing }
WDCameraState >> exposure: anObject [

	exposure := anObject
]

{ #category : #accessing }
WDCameraState >> farDistance [

	^ farDistance
]

{ #category : #accessing }
WDCameraState >> farDistance: anObject [

	farDistance := anObject
]

{ #category : #accessing }
WDCameraState >> frustum [

	^ frustum
]

{ #category : #accessing }
WDCameraState >> frustum: anObject [

	frustum := anObject
]

{ #category : #initialization }
WDCameraState >> initialize [
	super initialize.
	projectionMatrix := Matrix4x4 identity.
	frustum := Frustum new.
	currentTime := 0.0.
	exposure := 1.0.
]

{ #category : #accessing }
WDCameraState >> nearDistance [

	^ nearDistance
]

{ #category : #accessing }
WDCameraState >> nearDistance: anObject [

	nearDistance := anObject
]

{ #category : #accessing }
WDCameraState >> projectionMatrix [

	^ projectionMatrix
]

{ #category : #accessing }
WDCameraState >> projectionMatrix: anObject [

	projectionMatrix := anObject
]
