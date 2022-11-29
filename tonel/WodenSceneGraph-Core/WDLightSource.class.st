"
I represent a specific light source.
"
Class {
	#name : #WDLightSource,
	#superclass : #Object,
	#instVars : [
		'intensity',
		'castShadows',
		'shadowMapDepthBiasConstant',
		'shadowMapDepthBiasSlope',
		'shadowMapNormalBiasFactor',
		'color'
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

{ #category : #accessing }
WDLightSource >> color [
	^ color
]

{ #category : #accessing }
WDLightSource >> color: aColorOrVector3 [
	color := aColorOrVector3 asVector3
]

{ #category : #initialization }
WDLightSource >> initialize [
	super initialize.
	color := Vector3 ones.
	intensity := 1.0.
	castShadows := false.
	shadowMapDepthBiasConstant := 2.0.
	shadowMapDepthBiasSlope := 1.0.
	shadowMapNormalBiasFactor := 0.005.
]

{ #category : #accessing }
WDLightSource >> intensity [

	^ intensity
]

{ #category : #accessing }
WDLightSource >> intensity: aNumber [
	intensity := aNumber
]

{ #category : #accessing }
WDLightSource >> shadowMapDepthBiasConstant [

	^ shadowMapDepthBiasConstant
]

{ #category : #accessing }
WDLightSource >> shadowMapDepthBiasConstant: anObject [

	shadowMapDepthBiasConstant := anObject
]

{ #category : #accessing }
WDLightSource >> shadowMapDepthBiasSlope [

	^ shadowMapDepthBiasSlope
]

{ #category : #accessing }
WDLightSource >> shadowMapDepthBiasSlope: anObject [

	shadowMapDepthBiasSlope := anObject
]

{ #category : #accessing }
WDLightSource >> shadowMapNormalBiasFactor [

	^ shadowMapNormalBiasFactor
]

{ #category : #accessing }
WDLightSource >> shadowMapNormalBiasFactor: anObject [

	shadowMapNormalBiasFactor := anObject
]
