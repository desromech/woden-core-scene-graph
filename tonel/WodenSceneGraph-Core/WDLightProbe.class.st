"
I hold a collection of textures used for image based lighting.
"
Class {
	#name : #WDLightProbe,
	#superclass : #Object,
	#instVars : [
		'environment',
		'diffuse',
		'specular'
	],
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #construction }
WDLightProbe class >> forHDRIFileReference: aFileReference [
	^ self forHDRITexture: (WDTexture forHDRIFileReference: aFileReference)
]

{ #category : #construction }
WDLightProbe class >> forHDRITexture: aTexture [
	^ self new setupForHDRITexture: aTexture
]

{ #category : #accessing }
WDLightProbe >> diffuse [

	^ diffuse
]

{ #category : #accessing }
WDLightProbe >> diffuse: anObject [

	diffuse := anObject
]

{ #category : #accessing }
WDLightProbe >> environment [

	^ environment
]

{ #category : #accessing }
WDLightProbe >> environment: anObject [

	environment := anObject
]

{ #category : #setup }
WDLightProbe >> setupForEnvironment: anEnvironmentTexture [
	environment := anEnvironmentTexture.
	diffuse := WDTexture diffuseLightProbeWithSize: 32 forEnvironmentMap: anEnvironmentTexture.
	specular := WDTexture specularLightProbeWithSize: 128 forEnvironmentMap: anEnvironmentTexture.
]

{ #category : #setup }
WDLightProbe >> setupForHDRITexture: hdri [
	self setupForEnvironment: (WDTexture environmentMapWithSize: 512 forHDRITexture: hdri)
]

{ #category : #accessing }
WDLightProbe >> specular [

	^ specular
]

{ #category : #accessing }
WDLightProbe >> specular: anObject [

	specular := anObject
]
