"
I represent a specific light source.
"
Class {
	#name : #WDLightSource,
	#superclass : #Object,
	#instVars : [
		'intensity',
		'castShadows'
	],
	#category : #'WodenSceneGraph-Core-Lighting'
}

{ #category : #testing }
WDLightSource class >> isAbstract [
	^ self == WDLightSource
]

{ #category : #converting }
WDLightSource >> addToRenderingScene: renderingScene withGlobalTransform: globalTransform [
	self subclassResponsibility
]

{ #category : #converting }
WDLightSource >> asLightStateForRenderingScene: renderingScene withTransform: renderingTransform [
	self subclassResponsibility
]

{ #category : #converting }
WDLightSource >> asSceneElement [
	^ self asSceneNode
]

{ #category : #converting }
WDLightSource >> asSceneNode [
	^ WDSceneNode new
		lights: { self };
		yourself
]

{ #category : #accessing }
WDLightSource >> boundingBox [
	^ AABox fullSpace
]

{ #category : #accessing }
WDLightSource >> castShadows [

	^ castShadows
]

{ #category : #accessing }
WDLightSource >> castShadows: anObject [

	castShadows := anObject
]

{ #category : #initialization }
WDLightSource >> initialize [
	super initialize.
	intensity := Vector3 ones.
	castShadows := false.
]

{ #category : #accessing }
WDLightSource >> intensity [

	^ intensity
]

{ #category : #accessing }
WDLightSource >> intensity: aVector3 [
	intensity := aVector3 asVector3.
]
