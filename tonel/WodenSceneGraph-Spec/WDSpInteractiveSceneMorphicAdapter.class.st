Class {
	#name : 'WDSpInteractiveSceneMorphicAdapter',
	#superclass : 'WDSpSceneMorphicAdapter',
	#category : 'WodenSceneGraph-Spec',
	#package : 'WodenSceneGraph-Spec'
}

{ #category : 'accessing' }
WDSpInteractiveSceneMorphicAdapter class >> adaptingName [
	^ #WodenInteractiveSceneAdapter
]

{ #category : 'hooks' }
WDSpInteractiveSceneMorphicAdapter >> sceneMorphClass [
	^ WDInteractiveSceneMorph
]
