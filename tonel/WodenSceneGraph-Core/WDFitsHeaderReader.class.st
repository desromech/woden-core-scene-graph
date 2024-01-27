"
I am an utility used for reading textures in fits format, an image file format typically used in astronomy.
"
Class {
	#name : #WDFitsHeaderReader,
	#superclass : #Object,
	#instVars : [
		'stream',
		'properties'
	],
	#classVars : [
		'TextureFormatMap',
		'TextureTypeMap'
	],
	#category : #'WodenSceneGraph-Core-Texture'
}

{ #category : #'class initialization' }
WDFitsHeaderReader class >> initialize [
	TextureFormatMap := Dictionary newFromPairs: { 
		8 . WDTextureFormatR8UNorm.
		16 . WDTextureFormatR16UNorm.

		-32 . WDTextureFormatR32Float.
	}.
	
	TextureTypeMap := Dictionary newFromPairs: { 
		1 . WDTextureType1D.
		2 . WDTextureType2D.
		3 . WDTextureType3D.
	}.
]

{ #category : #accessing }
WDFitsHeaderReader >> bitpix [
	^ (properties at: 'BITPIX') asInteger
]

{ #category : #initialization }
WDFitsHeaderReader >> initialize [
	properties := Dictionary new.
]

{ #category : #accessing }
WDFitsHeaderReader >> naxis [
	^ (properties at: 'NAXIS') asInteger
]

{ #category : #accessing }
WDFitsHeaderReader >> naxis1 [
	^ (properties at: 'NAXIS1' ifAbsent: ['1']) asInteger
]

{ #category : #accessing }
WDFitsHeaderReader >> naxis2 [
	^ (properties at: 'NAXIS2' ifAbsent: ['1']) asInteger
]

{ #category : #accessing }
WDFitsHeaderReader >> naxis3 [
	^ (properties at: 'NAXIS3' ifAbsent: ['1']) asInteger
]

{ #category : #accessing }
WDFitsHeaderReader >> properties [

	^ properties
]

{ #category : #'private - decoding' }
WDFitsHeaderReader >> readHeader [
	| startPosition nextProperty headerSize remainingHeader |
	startPosition := stream position.
	[
		nextProperty := self readHeaderLine.
		nextProperty ifNotNil: [ 
			nextProperty key = 'END' ifTrue: [ 
				false
			] ifFalse: [ 
				properties add: nextProperty.
				true
			]
		] ifNil: [
			false
		]
	] whileTrue.

	headerSize := stream position - startPosition.
	remainingHeader := 2880 - (headerSize % 2880).
	stream skip: remainingHeader.
	
]

{ #category : #'private - decoding' }
WDFitsHeaderReader >> readHeaderLine [
	| headerLine key value valueString commentIndex |
	headerLine := (stream next: 80) asString.
	key := (headerLine first: 8) reject: [:c | c isSpaceSeparator ].
	value := nil.
	((headerLine at: 9) = $= and: [ (headerLine at: 10) = Character space ]) ifTrue: [ 
		valueString := headerLine allButFirst: 10.
		commentIndex := valueString indexOf: $/.
		commentIndex > 0 ifTrue: [ 
			valueString := valueString first: commentIndex - 1
		].
		value := valueString reject: [:c | c isSpaceSeparator ].
	].
	
	^ key -> value
]

{ #category : #'as yet unclassified' }
WDFitsHeaderReader >> readTextureData [
	| width height depth bitsPerPixel bytesPerPixel dataSize data pitch slicePitch |
	width := self naxis1.
	height := self naxis2.
	depth := self naxis3.
	bitsPerPixel := self bitpix abs.
	bytesPerPixel := bitsPerPixel / 8.
	pitch := width*bytesPerPixel.
	slicePitch := pitch*height.
	dataSize := slicePitch*depth.
	data := stream next: dataSize.
	
	^ WDFitsTextureData new
		width: width;
		height: height;
		depth: depth;
		pitch: pitch;
		slicePitch: slicePitch;
		bytes: data;
		yourself
]

{ #category : #accessing }
WDFitsHeaderReader >> stream [

	^ stream
]

{ #category : #accessing }
WDFitsHeaderReader >> stream: anObject [

	stream := anObject
]

{ #category : #'as yet unclassified' }
WDFitsHeaderReader >> textureFormat [
	^ TextureFormatMap at: self bitpix
]

{ #category : #'as yet unclassified' }
WDFitsHeaderReader >> textureType [
	^ TextureTypeMap at: self naxis
]
