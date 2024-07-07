"
I am a buffer that holds a single sound sample.
"
Class {
	#name : 'WDSoundSample',
	#superclass : 'WDRendererCacheableResource',
	#instVars : [
		'name',
		'channels',
		'format',
		'sampleRate',
		'data'
	],
	#category : 'WodenSceneGraph-Core-Sound',
	#package : 'WodenSceneGraph-Core',
	#tag : 'Sound'
}

{ #category : 'digital filters' }
WDSoundSample class >> biquadraticFilterWithCoefficient: coefficients [
	| a0 na1 na2 nb0 nb1 nb2 |
	a0 := coefficients first.
	na1 := coefficients second / a0.
	na2 := coefficients third / a0.
	nb0 := coefficients fourth / a0.
	nb1 := coefficients fifth / a0.
	nb2 := coefficients sixth / a0.

	^ [ :x :x1 :y1 :x2 :y2 |
		(nb0*x) + (nb1*x1) + (nb2*x2) - (na1*y1) - (na2*y2)
	]
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseSamples: sampleCount withRate: sampleRate amplitude: amplitude seed: randomSeed [
	| random |
	random := Random seed: randomSeed.
	^ self generateSamples: sampleCount withRate: sampleRate with: [(random next*2.0 - 1.0) * amplitude]
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseSamples: sampleCount withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency [
	| random |
	random := Random seed: randomSeed.
	^ self generateSamples: sampleCount withRate: sampleRate with: [(random next*2.0 - 1.0) * amplitude] thenFilter2: (self lowPassFilterWithSampleRate: sampleRate frequency: cutoffFrequency)
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseSamples: sampleCount withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency q: q [
	| random |
	random := Random seed: randomSeed.
	^ self generateSamples: sampleCount withRate: sampleRate with: [(random next*2.0 - 1.0) * amplitude] thenFilter2: (self lowPassFilterWithSampleRate: sampleRate frequency: cutoffFrequency q: q)
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseWithDuration: duration withRate: sampleRate amplitude: amplitude seed: randomSeed [
	^ self generateNoiseSamples: (duration * sampleRate) rounded withRate: sampleRate amplitude: amplitude seed: randomSeed
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseWithDuration: duration withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency [
	^ self generateNoiseSamples: (duration * sampleRate) rounded withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency
]

{ #category : 'generation' }
WDSoundSample class >> generateNoiseWithDuration: duration withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency q: q [
	^ self generateNoiseSamples: (duration * sampleRate) rounded withRate: sampleRate amplitude: amplitude seed: randomSeed lowPassCutoff: cutoffFrequency q: q
]

{ #category : 'generation' }
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

{ #category : 'generation' }
WDSoundSample class >> generateSamples: sampleCount withRate: sampleRate with: aBlock thenFilter2: aFilterBlock [
	| data destIndex dt x1 x2 y1 y2 |
	data := ByteArray new: sampleCount * 2.
	x1 := 0.0.
	x2 := 0.0.
	y1 := 0.0.
	y2 := 0.0.

	destIndex := 1.
	dt := 1.0 / sampleRate.
	1 to: sampleCount do: [ :i |
		| t x y |
		t := (i - 1) * dt.
		x := aBlock cull: t cull: dt cull: i.
		y := aFilterBlock valueWithArguments: {x . x1 . y1 . x2 . y2}.

		data signedShortAt: destIndex put: ((y min: 1.0 max: -1.0) * 32767) rounded.
		destIndex := destIndex + 2.

		x2 := x1.
		x1 := x.

		y2 := y1.
		y1 := y.
	].

	^ self new
		format: WDSoundSampleFormatMono16SNorm;
		sampleRate: sampleRate;
		data: data;
		yourself
]

{ #category : 'digital filters' }
WDSoundSample class >> lowPassFilterWithSampleRate: sampleRate frequency: cutoffFrequency [
	"See https://en.wikipedia.org/wiki/Low-pass_filter"
	| omega0 alpha |
	omega0 := 2.0 * Float twoPi * cutoffFrequency / sampleRate.
	alpha := omega0 / (omega0 + 1).
	^ [ :x :x1 :y1 :x2 :y2 |
		y1 + (alpha * (x - y1))
	]
]

{ #category : 'digital filters' }
WDSoundSample class >> lowPassFilterWithSampleRate: sampleRate frequency: cutoffFrequency q: q [
	"See https://www.w3.org/TR/audio-eq-cookbook/ and https://en.wikipedia.org/wiki/Digital_biquad_filter"
	| omega0 co so alpha b0 b1 b2 a0 a1 a2 |
	omega0 := 2.0 * Float twoPi * cutoffFrequency / sampleRate.
	co := omega0 cos.
	so := omega0 sin.
	alpha := so / (2.0 * q).
	
	b0 := (1.0 - co) / 2.
	b1 := 1.0 - co.
	b2 := (1.0 - co) / 2.
	a0 := 1 + alpha.
	a1 := -2*co.
	a2 := 1 - alpha.
	^ self biquadraticFilterWithCoefficient: { a0 . a1 . a2 . b0 . b1 . b2 }
]

{ #category : 'accessing' }
WDSoundSample >> data [

	^ data
]

{ #category : 'accessing' }
WDSoundSample >> data: anObject [

	data := anObject
]

{ #category : 'accessing' }
WDSoundSample >> format [

	^ format
]

{ #category : 'accessing' }
WDSoundSample >> format: aSoundSampleFormat [
	format := aSoundSampleFormat asSoundSampleFormat
]

{ #category : 'accessing' }
WDSoundSample >> name [

	^ name
]

{ #category : 'accessing' }
WDSoundSample >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WDSoundSample >> sampleRate [

	^ sampleRate
]

{ #category : 'accessing' }
WDSoundSample >> sampleRate: anObject [

	sampleRate := anObject
]
