"
I am a reader for wav files.
"
Class {
	#name : #WDSRWWaveFileReader,
	#superclass : #Object,
	#classVars : [
		'SoundSampleFormatDictionary',
		'WaveFormatALaw',
		'WaveFormatIEEEFloat',
		'WaveFormatMuLaw',
		'WaveFormatPCM'
	],
	#category : #'WodenSceneGraph-ReadWriter-WAV'
}

{ #category : #'class initialization' }
WDSRWWaveFileReader class >> initialize [
	WaveFormatPCM := 1.
	WaveFormatIEEEFloat := 3.
	WaveFormatALaw := 6.
	WaveFormatMuLaw := 7.
	
	SoundSampleFormatDictionary := Dictionary newFromPairs: {
		"Format . Channels . Bits per Sample"
		{ WaveFormatPCM . 1 .  8 } . WDSoundSampleFormatMono8UNorm asSoundSampleFormat.
		{ WaveFormatPCM . 1 . 16 } . WDSoundSampleFormatMono16SNorm asSoundSampleFormat.
		{ WaveFormatPCM . 2 .  8 } . WDSoundSampleFormatStereo8UNorm asSoundSampleFormat.
		{ WaveFormatPCM . 2 . 16 } . WDSoundSampleFormatStereo16SNorm asSoundSampleFormat.
	}
]

{ #category : #documentation }
WDSRWWaveFileReader class >> readFromFileReference: aFileReference [
	^ self new readFromFileReference: aFileReference
]

{ #category : #parsing }
WDSRWWaveFileReader >> parseWaveData: contents [
	"See https://www.mmsp.ece.mcgill.ca/Documents/AudioFormats/WAVE/WAVE.html for a spec."
	| chunkID waveFileChunkSize waveID fmtChunkSize readIndex fmtChunkEndOffset formatTag numberOfChannels sampleRate dataRate dataBlockSize bitsPerSample sampleFormat dataChunkSize samples |
	readIndex := 1.
	chunkID := (contents copyFrom: readIndex to: readIndex + 3) asString. readIndex := readIndex + 4.
	chunkID = 'RIFF' ifFalse: [ self error: 'Invalid wave file header.' ].

	waveFileChunkSize := contents unsignedLongAt: readIndex. readIndex := readIndex + 4.
	waveFileChunkSize >= 4 ifFalse: [ self error: 'Invalid wave file header.' ].

	waveID := (contents copyFrom: readIndex to: readIndex + 3) asString. readIndex := readIndex + 4.
	waveID = 'WAVE' ifFalse: [ self error: 'Invalid wave file header.' ].

	chunkID := (contents copyFrom: readIndex to: readIndex + 3) asString. readIndex := readIndex + 4.
	chunkID = 'fmt ' ifFalse: [ self error: 'Expected fmt chunk.' ].

	fmtChunkSize := contents unsignedLongAt: readIndex. readIndex := readIndex + 4.
	(#(16 18 40) includes: fmtChunkSize) ifFalse: [ self error: 'Invalid fmt chunk size.' ].
	fmtChunkEndOffset := readIndex + fmtChunkSize.
	
	formatTag := contents unsignedShortAt: readIndex. readIndex := readIndex + 2.
	numberOfChannels := contents unsignedShortAt: readIndex. readIndex := readIndex + 2.
	sampleRate := contents unsignedLongAt: readIndex. readIndex := readIndex + 4.
	dataRate := contents unsignedLongAt: readIndex. readIndex := readIndex + 4.
	dataBlockSize := contents unsignedShortAt: readIndex. readIndex := readIndex + 2.
	bitsPerSample := contents unsignedShortAt: readIndex. readIndex := readIndex + 2.

	sampleFormat := SoundSampleFormatDictionary at: { formatTag . numberOfChannels . bitsPerSample  } ifAbsent: [
		self error: 'Unsupported wave file format.'
	].

	readIndex := fmtChunkEndOffset.

	chunkID := (contents copyFrom: readIndex to: readIndex + 3) asString. readIndex := readIndex + 4.
	chunkID = 'data' ifFalse: [ self error: 'Expected data chunk.' ].

	dataChunkSize := contents unsignedLongAt: readIndex. readIndex := readIndex + 4.
	samples := contents copyFrom: readIndex to: (readIndex + dataChunkSize - 1 min: contents size).

	^ WDSoundSample new
		format: sampleFormat;
		sampleRate: sampleRate;
		data: samples;
		yourself
]

{ #category : #documentation }
WDSRWWaveFileReader >> readFromFileReference: fileRef [
	^ fileRef binaryReadStreamDo: [ :fin |
		self parseWaveData: fin contents
	]
]
