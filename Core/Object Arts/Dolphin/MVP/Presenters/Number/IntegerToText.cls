"Filed out from Dolphin Smalltalk X6"!

NumberToText subclass: #IntegerToText
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IntegerToText guid: (GUID fromString: '{87B4C70B-026E-11D3-9FD7-00A0CC3E4A32}')!
IntegerToText comment: 'IntegerToText is a <textTypeConverter> which transforms an <integer> subject value to/from a <readableString>. If the subject value is nil it is converted to an empty string and vice versa.'!
!IntegerToText categoriesForClass!MVP-Type Converters-Text! !
!IntegerToText methodsFor!

rightToLeft: aString
	"Answers the result of converting aStringOrNil to an Integer. If aStringOrNil is
	empty or nil then answer leftExceptionalValue to represent this"

	^Integer fromString: aString! !
!IntegerToText categoriesFor: #rightToLeft:!operations!public! !

