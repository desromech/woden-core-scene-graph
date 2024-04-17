"
I am a buffer that holds a single sound sample.
"
Class {
	#name : #WDSoundSample,
	#superclass : #WDRendererCacheableResource,
	#instVars : [
		'name',
		'channels',
		'format',
		'sampleRate',
		'data'
	],
	#category : #'WodenSceneGraph-Core-Sound'
}

{ #category : #generation }
WDSoundSample class >> generateNoiseSamples: sampleCount withRate: sampleRate amplitude: amplitude seed: randomSeed [
	| random |
	random := Random seed: randomSeed.
	^ self generateSamples: sampleCount withRate: sampleRate with: [(random next*2.0 - 1.0) * amplitude]
]

{ #category : #generation }
WDSoundSample class >> generateNoiseWithDuration: duration withRate: sampleRate amplitude: amplitude seed: randomSeed [
	^ self generateNoiseSamples: (duration * sampleRate) rounded withRate: sampleRate amplitude: amplitude seed: randomSeed
]

{ #category : #generation }
WDSoundSample class >> generateSamples: sampleCount withRate: sampleRate with: aBlock [
	| data destIndex dt |
	data := ByteArray new: sampleCount * 2.

	destIndex := 1.
	dt := 1.0 / sampleRate.
	1 to: sampleCount do: [ :i |
		| t sampleValue |
		t := (i - 1) * dt.
		sampleValue := aBlock cull: t cull: dt cull: i.
		data signedShortAt: destIndex put: ((sampleValue min: 1.0 max: -1.0) * 32767) rounded.
		destIndex := destIndex + 2.
	].

	^ self new
		format: WDSoundSampleFormatMono16SNorm;
		sampleRate: sampleRate;
		data: data;
		yourself
]

{ #category : #accessing }
WDSoundSample >> data [

	^ data
]

{ #category : #accessing }
WDSoundSample >> data: anObject [

	data := anObject
]

{ #category : #accessing }
WDSoundSample >> format [

	^ format
]

{ #category : #accessing }
WDSoundSample >> format: aSoundSampleFormat [
	format := aSoundSampleFormat asSoundSampleFormat
]

{ #category : #accessing }
WDSoundSample >> name [

	^ name
]

{ #category : #accessing }
WDSoundSample >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDSoundSample >> sampleRate [

	^ sampleRate
]

{ #category : #accessing }
WDSoundSample >> sampleRate: anObject [

	sampleRate := anObject
]
