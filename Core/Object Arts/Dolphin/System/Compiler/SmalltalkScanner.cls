"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #SmalltalkScanner
	instanceVariableNames: 'stream buffer tokenStart currentCharacter characterType classificationTable separatorsInLiterals extendedLiterals comments errorBlock nameSpaceCharacter line errorHandler'
	classVariableNames: 'ClassificationTable PatternVariableCharacter'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
SmalltalkScanner guid: (GUID fromString: '{F76F2335-9125-488E-A570-5A759A6E67B7}')!
SmalltalkScanner comment: 'SmalltalkScanner is the Smalltalk lexical analyzer. It converts source text to a stream of <StToken>''s.

Note that SmalltalkScanner is based on the RBScanner class written by John Brant and Don Roberts for their Refactoring Browser. It has been extended for Dolphin to incorporate additional error reporting capabilities (such as the line number on which the error occurred), and the ability to parse Dolphin''s FFI call syntax.

Instance Variables:
	stream				<ReadStream> Input stream (method/expression source)
	buffer				<WriteStream> Token building buffer.
	tokenStart			<integer> position in stream at which current token starts.
	currentCharacter		<Character> last character read from stream.
	characterType		<Symbol>. Symbolic type of last character read from stream.
	classificationTable	<Array> of <Symbol>. Symbolic types of each possible character (one slot per code point).
	separatorsInLiterals	<boolean>. Whether to allow whitespace in literal constants.
	extendedLiterals		<boolean>. Whether extended literal constants (prefixed with ##) are parsed.
	comments			<OrderedCollection> of <Interval>. Ranges of the source occuppied by comments.
	errorBlock			<dyadicValuable> evaluated on encountering lexical errors
	nameSpaceCharacter	<Character>. Namespace separator character (not currently used on Dolphin)
	line					<integer> line number of current token.

Class Instance Variables:
	classificationTable	<Array>. Used to classify characters into types.

'!
!SmalltalkScanner categoriesForClass!System-Compiler! !
!SmalltalkScanner methodsFor!

atEnd
	^characterType == #eof!

characterExpected
	self lexicalError: LErrExpectChar.
	^self recoverFromExpectChar!

classify: aCharacter 
	| index |
	"May be asked to classify nil if peek at end of stream"
	aCharacter isNil ifTrue: [^#separator].
	(index := aCharacter asInteger) == 0 ifTrue: [^#separator].
	"Currently Dolphin supports only single-byte characters, so this test is redundant"
	"index > 255 ifTrue: [^nil]."
	^classificationTable at: index!

constantExpected
	self lexicalError: LErrExpectConst.
	^self recoverFromUnterminatedLiteral!

contents
	| contentsStream |
	contentsStream := WriteStream on: (Array new: 50).
	self do: [:each | contentsStream nextPut: each].
	^contentsStream contents!

do: aBlock
	"Evaluate the argument, aBlock, for each of the remaining elements that can be accessed by 
	the receiver."

	[self atEnd] whileFalse: [aBlock value: self next]
!

errorBlock
	^errorBlock ifNil: [[:ex | ]]!

errorBlock: aBlock 
	errorBlock := aBlock 
				ifNotNil: 
					[aBlock argumentCount == 2 
						ifTrue: 
							[
							[:ex | 
							aBlock value: ex description value: ex position.
							ex signal]]
						ifFalse: [aBlock]]!

errorHandler
	^errorHandler!

errorHandler: parseErrorHandler 
	errorHandler := parseErrorHandler!

errorPosition
	^stream position!

extendedLiteralExpected
	self lexicalError: LErrExpectExtendedLiteral.
	^self recoverFromUnterminatedLiteral!

getComments
	| oldComments |
	comments isEmpty ifTrue: [^nil].
	oldComments := comments.
	comments := OrderedCollection new: 1.
	^oldComments!

identifierTokenClass
	^StIdentifierToken!

illegalCharacter
	self lexicalError: LErrBadChar range: (self errorPosition to: self errorPosition).
	"Error ignored, attempt to recover"
	^self recoverFromIllegalCharacter!

illegalNumber: anInteger 
	self lexicalError: LErrBadNumber range: (anInteger to: self errorPosition).
	^self recoverFromIllegalNumber: anInteger!

initializeForDolphin
	separatorsInLiterals := false.
	extendedLiterals := true.
	nameSpaceCharacter := $..	"N.B. Dolphin does not currently support namespaces."
	line := 1!

invalidQualifier
	^self lexicalError: LErrInvalidQualifier!

lexicalError: anInteger
	^self lexicalError: anInteger range: (tokenStart to: self errorPosition)!

lexicalError: anInteger range: anInterval 
	^self 
		lexicalError: anInteger
		range: anInterval
		extras: #()!

lexicalError: anInteger range: anInterval extras: anArray 
	^self errorHandler 
		reportError: anInteger
		at: self errorPosition
		line: self line
		range: anInterval
		extras: anArray!

line
	"Anwswer one-based <integer> line number of the receiver's current position in the 
	source text."

	^line!

literalErrorToken: anObject start: anInteger 
	^self literalTokenClass 
		value: anObject
		start: tokenStart
		stop: anInteger!

literalTokenClass
	^StLiteralToken!

metaVariableExpected
	^self lexicalError: LErrExpectMetaVariable!

namespaceCharacter: aCharacter
	nameSpaceCharacter := aCharacter!

next
	| token |
	buffer reset.
	tokenStart := stream position.
	token := characterType == #eof 
				ifTrue: 
					[StToken start: tokenStart + 1	"The EOF token should occur after the end of input"]
				ifFalse: [self scanToken].
	self stripSeparators.
	token comments: self getComments.
	^token!

notificationClass
	^SmalltalkParser notificationClass!

numberTokenClass
	^StNumberLiteralToken!

on: aStream 
	buffer := WriteStream on: (String new: 60).
	stream := aStream.
	tokenStart := stream position.
	classificationTable := self class classificationTable.
	comments := OrderedCollection new.
	errorHandler := self.
	self initializeForDolphin!

previousStepPosition
	^characterType == #eof 
		ifTrue: [stream position]
		ifFalse: [stream position - 1]!

readNumber
	| number |
	stream skip: -1.
	number := Number readSmalltalkSyntaxFrom: stream.
	self step.
	^number!

recoverFromIllegalCharacter
	| start badChar |
	badChar := currentCharacter.
	start := tokenStart.
	"Skip the bad character"
	self step.
	^StIllegalCharacterToken value: badChar start: start!

recoverFromIllegalNumber: anInteger 
	^self literalErrorToken: (stream copyFrom: anInteger to: self previousStepPosition) start: anInteger!

recoverFromUnterminatedComment: anInteger 
	characterType := #eof.
	currentCharacter := nil.
	comments add: (anInteger to: stream position)!

reportError: anInteger at: posInteger line: lineInteger range: anInterval extras: anArray 
	| err |
	err := self notificationClass 
				code: anInteger
				in: stream contents
				for: Object
				selector: #unknown
				position: posInteger
				line: lineInteger
				range: anInterval
				extras: anArray.
	self errorBlock value: err.
	"If the error block returns, then the exception is signalled"
	^err signal!

scanAnySymbol
	characterType == #alphabetic ifTrue: [^self scanSymbol].
	characterType == #binary 
		ifTrue: [^self scanBinary: self literalTokenClass].
	^StToken new!

scanBinary: aClass
	"Private - Although this does now permit binary selectors to be any length, as mandated by the ANSI
	standard, it still deliberately excludes '-' to avoid the ambiguity in expressions such as: '1--2'. The ANSI
	standard requires that this expression should be treated as a single send of the binary selector #-- to
	1 with 2 as its argument, however Smalltalk has traditionally treated this as '1 - -2', one subtract minus two."

	| val |
	buffer nextPut: currentCharacter.
	self step.
	[characterType == #binary and: [currentCharacter ~~ $-]] whileTrue: 
			[buffer nextPut: currentCharacter.
			self step].
	val := buffer contents.
	val := val asSymbol.
	^aClass value: val start: tokenStart!

scanExtendedLiterals
	| token |
	self step.
	separatorsInLiterals ifTrue: [self stripSeparators].
	token := characterType == #alphabetic 
				ifTrue: [self scanSymbol]
				ifFalse: 
					[characterType == #binary 
						ifTrue: [(self scanBinary: self literalTokenClass) stop: self previousStepPosition]
						ifFalse: 
							[currentCharacter == $' 
								ifTrue: [self scanStringSymbol]
								ifFalse: [currentCharacter == $( ifTrue: [^self scanOptimized]]]].
	token isNil ifTrue: [^self extendedLiteralExpected].
	token value: ((Smalltalk at: #EsAtom ifAbsent: [Symbol]) intern: token value asString).
	^token!

scanIdentifierOrKeyword
	| name |
	self scanName.
	currentCharacter == nameSpaceCharacter 
		ifTrue: 
			[| token |
			token := self scanNameSpaceName.
			token notNil ifTrue: [^token]].
	(currentCharacter == $: and: [stream peek ~~ $=]) ifTrue: [^self scanKeyword].
	name := buffer contents.
	name = 'true' 
		ifTrue: 
			[^self literalTokenClass 
				value: true
				start: tokenStart
				stop: self previousStepPosition].
	name = 'false' 
		ifTrue: 
			[^self literalTokenClass 
				value: false
				start: tokenStart
				stop: self previousStepPosition].
	name = 'nil' 
		ifTrue: 
			[^self literalTokenClass 
				value: nil
				start: tokenStart
				stop: self previousStepPosition].
	^self identifierTokenClass value: name start: tokenStart!

scanKeyword
	| outputPosition inputPosition words |
	words := 0.
	
	[words := words + 1.
	buffer nextPut: currentCharacter.
	outputPosition := buffer position.
	inputPosition := stream position.
	self step.	":"
	characterType == #alphabetic and: 
			[self scanName.
			currentCharacter == $:]] 
			whileTrue.
	"Restore to position immediately after last colon"
	buffer position: outputPosition.
	stream position: inputPosition.
	self step.
	^words == 1 
		ifTrue: [StKeywordToken value: buffer contents start: tokenStart]
		ifFalse: 
			[| name |
			name := buffer contents.
			StMultiKeywordLiteralToken 
				value: name asSymbol
				start: tokenStart
				stop: tokenStart + name size - 1]!

scanLiteral
	self step.
	separatorsInLiterals ifTrue: [self stripSeparators].
	characterType == #alphabetic ifTrue: [^self scanSymbol].
	characterType == #binary 
		ifTrue: [^(self scanBinary: self literalTokenClass) stop: self previousStepPosition].
	currentCharacter == $' ifTrue: [^self scanStringSymbol].
	(currentCharacter == $( or: [currentCharacter == $[]) 
		ifTrue: [^self scanLiteralArrayToken].
	(separatorsInLiterals and: [currentCharacter == ${]) 
		ifTrue: [^self scanQualifiedReference].
	(extendedLiterals and: [currentCharacter == $#]) ifTrue: [^self scanExtendedLiterals].
	^self constantExpected!

scanLiteralArrayToken
	| token |
	token := StLiteralArrayToken value: (String with: $# with: currentCharacter)
				start: tokenStart.
	self step.
	^token!

scanLiteralCharacter
	| token |
	self step.	"$"
	self atEnd ifTrue: [^self characterExpected].
	token := self literalTokenClass 
				value: currentCharacter
				start: tokenStart
				stop: stream position.
	self step.	"char"
	^token!

scanLiteralString
	self step.
	
	[currentCharacter isNil ifTrue: [^self unterminatedString].
	currentCharacter == $' and: [self step ~~ $']] 
			whileFalse: 
				[buffer nextPut: currentCharacter.
				self step].
	^self literalTokenClass 
		value: buffer contents
		start: tokenStart
		stop: self previousStepPosition!

scanName
	[characterType == #alphabetic or: [characterType == #digit]] whileTrue: 
			[buffer nextPut: currentCharacter.
			self step]!

scanNameSpaceName
	nameSpaceCharacter == $: 
		ifTrue: 
			[stream peek == $: ifFalse: [^nil].
			buffer next: 2 put: $:.
			self step]
		ifFalse: 
			[(stream atEnd or: [(self classify: stream peek) ~~ #alphabetic]) ifTrue: [^nil].
			buffer nextPut: $.].
	self step.
	self scanName.
	currentCharacter == nameSpaceCharacter ifTrue: [^self scanNameSpaceName].
	^StIdentifierToken value: buffer contents start: tokenStart!

scanNumber
	| start number stop |
	start := stream position.
	number := [self readNumber] on: Error
				do: 
					[:ex | 
					self illegalNumber: start.
					0].
	stop := self previousStepPosition.
	^self numberTokenClass 
		value: number
		start: start
		stop: stop
		source: (stream copyFrom: start to: stop)!

scanOptimized
	self step.
	^StOptimizedToken start: tokenStart stop: self previousStepPosition!

scanPatternVariable
	buffer nextPut: currentCharacter.
	self step.
	currentCharacter == ${ 
		ifTrue: 
			[self step.
			^PatternBlockToken value: '`{' start: tokenStart].
	[characterType == #alphabetic] whileFalse: 
			[characterType == #eof ifTrue: [^self metaVariableExpected].
			buffer nextPut: currentCharacter.
			self step].
	^self scanIdentifierOrKeyword!

scanQualifiedReference
	| nameToken bindingClass |
	bindingClass := Smalltalk at: #BindingReference ifAbsent: [nil].
	bindingClass isNil ifTrue: [^self illegalCharacter].
	self step.	"{"
	self stripSeparators.
	nameToken := self scanIdentifierOrKeyword.
	(nameToken isIdentifier and: [nameToken value notEmpty]) ifFalse: [self invalidQualifier].
	self stripSeparators.
	currentCharacter == $} ifFalse: [^self unterminatedQualifiedRef].
	self step.	"}"
	^self literalTokenClass 
		value: (bindingClass pathString: nameToken value)
		start: tokenStart
		stop: self previousStepPosition!

scanSpecialCharacter
	| character |
	currentCharacter == $: 
		ifTrue: 
			[self step.
			^currentCharacter == $= 
				ifTrue: 
					[self step.
					StAssignmentToken start: tokenStart]
				ifFalse: [StSpecialCharacterToken value: $: start: tokenStart]].
	character := currentCharacter.
	self step.
	^StSpecialCharacterToken value: character start: tokenStart!

scanStringSymbol
	| literalToken |
	literalToken := self scanLiteralString.
	literalToken value: literalToken value asSymbol.
	^literalToken!

scanSymbol
	| lastPosition hasColon value startPosition |
	hasColon := false.
	startPosition := lastPosition := stream position.
	[characterType == #alphabetic] whileTrue: 
			[self scanName.
			currentCharacter == $: 
				ifTrue: 
					[buffer nextPut: $:.
					hasColon := true.
					lastPosition := stream position.
					self step]].
	value := buffer contents.
	(hasColon and: [value last ~~ $:]) 
		ifTrue: 
			[stream position: lastPosition.
			self step.
			value := value copyFrom: 1 to: lastPosition - startPosition + 1].
	^self literalTokenClass
		value: value asSymbol
		start: tokenStart
		stop: self previousStepPosition!

scanToken
	"fast-n-ugly. Don't write stuff like this. Has been found to cause cancer in laboratory rats. Basically a 
	case statement. Didn't use Dictionary because lookup is pretty slow."

	characterType == #alphabetic ifTrue: [^self scanIdentifierOrKeyword].
	(characterType == #digit 
		or: [currentCharacter == $- and: [(self classify: stream peek) == #digit]]) 
			ifTrue: [^self scanNumber].
	characterType == #binary ifTrue: [^self scanBinary: StBinarySelectorToken].
	characterType == #special ifTrue: [^self scanSpecialCharacter].
	currentCharacter == $' ifTrue: [^self scanLiteralString].
	currentCharacter == $# ifTrue: [^self scanLiteral].
	currentCharacter == $$ ifTrue: [^self scanLiteralCharacter].
	^self illegalCharacter!

separatorsInLiterals: aBoolean
	separatorsInLiterals := aBoolean!

step
	| index |
	(currentCharacter := stream nextAvailable) isNil 
		ifTrue: 
			[characterType := #eof.
			^nil].
	characterType := (index := currentCharacter asInteger) == 0 
				ifTrue: [#separator]
				ifFalse: 
					[index == 10 ifTrue: [line := line + 1].
					classificationTable at: index].
	^currentCharacter!

stripComment
	"Private - Skip to the next end-of-comment marker."

	| start stop |
	start := stream position.
	
	[| ch |
	stream atEnd ifTrue: [^self unterminatedComment: start].
	ch := stream next.
	ch isLinefeed ifTrue: [line := line + 1].
	ch == $"] 
			whileFalse.
	stop := stream position.
	self step.
	"Do we need access to the comments?"
	comments add: (start to: stop)!

stripSeparators
	
	[[characterType == #separator] whileTrue: [self step].
	currentCharacter == $"] 
			whileTrue: [self stripComment]!

unterminatedComment: anInteger 
	self lexicalError: LErrCommentNotClosed range: (anInteger to: self errorPosition).
	^self recoverFromUnterminatedComment: anInteger!

unterminatedQualifiedRef
	^self lexicalError: LErrQualifiedRefNotClosed!

unterminatedString
	self lexicalError: LErrStringNotClosed.
	^self recoverFromUnterminatedLiteral! !
!SmalltalkScanner categoriesFor: #atEnd!public!testing! !
!SmalltalkScanner categoriesFor: #characterExpected!error handling!private! !
!SmalltalkScanner categoriesFor: #classify:!private!scanning! !
!SmalltalkScanner categoriesFor: #constantExpected!error handling!private! !
!SmalltalkScanner categoriesFor: #contents!accessing!public! !
!SmalltalkScanner categoriesFor: #do:!enumerating!public! !
!SmalltalkScanner categoriesFor: #errorBlock!error handling!public! !
!SmalltalkScanner categoriesFor: #errorBlock:!accessing!public! !
!SmalltalkScanner categoriesFor: #errorHandler!accessing!private! !
!SmalltalkScanner categoriesFor: #errorHandler:!accessing!private! !
!SmalltalkScanner categoriesFor: #errorPosition!accessing!error handling!public! !
!SmalltalkScanner categoriesFor: #extendedLiteralExpected!error handling!private! !
!SmalltalkScanner categoriesFor: #getComments!accessing!public! !
!SmalltalkScanner categoriesFor: #identifierTokenClass!constants!private! !
!SmalltalkScanner categoriesFor: #illegalCharacter!error handling!private! !
!SmalltalkScanner categoriesFor: #illegalNumber:!error handling!private! !
!SmalltalkScanner categoriesFor: #initializeForDolphin!initializing!public! !
!SmalltalkScanner categoriesFor: #invalidQualifier!private!scanning! !
!SmalltalkScanner categoriesFor: #lexicalError:!error handling!private! !
!SmalltalkScanner categoriesFor: #lexicalError:range:!error handling!private! !
!SmalltalkScanner categoriesFor: #lexicalError:range:extras:!error handling!private! !
!SmalltalkScanner categoriesFor: #line!accessing!public! !
!SmalltalkScanner categoriesFor: #literalErrorToken:start:!error handling!private! !
!SmalltalkScanner categoriesFor: #literalTokenClass!constants!private! !
!SmalltalkScanner categoriesFor: #metaVariableExpected!error handling!private! !
!SmalltalkScanner categoriesFor: #namespaceCharacter:!accessing!private! !
!SmalltalkScanner categoriesFor: #next!accessing!public! !
!SmalltalkScanner categoriesFor: #notificationClass!constants!error handling!private! !
!SmalltalkScanner categoriesFor: #numberTokenClass!public! !
!SmalltalkScanner categoriesFor: #on:!initializing!private! !
!SmalltalkScanner categoriesFor: #previousStepPosition!accessing!private! !
!SmalltalkScanner categoriesFor: #readNumber!private!scanning! !
!SmalltalkScanner categoriesFor: #recoverFromIllegalCharacter!error handling!private! !
!SmalltalkScanner categoriesFor: #recoverFromIllegalNumber:!error handling!private! !
!SmalltalkScanner categoriesFor: #recoverFromUnterminatedComment:!error handling!private! !
!SmalltalkScanner categoriesFor: #reportError:at:line:range:extras:!error handling!private! !
!SmalltalkScanner categoriesFor: #scanAnySymbol!private!scanning! !
!SmalltalkScanner categoriesFor: #scanBinary:!private!scanning! !
!SmalltalkScanner categoriesFor: #scanExtendedLiterals!private!scanning! !
!SmalltalkScanner categoriesFor: #scanIdentifierOrKeyword!private!scanning! !
!SmalltalkScanner categoriesFor: #scanKeyword!private!scanning! !
!SmalltalkScanner categoriesFor: #scanLiteral!private!scanning! !
!SmalltalkScanner categoriesFor: #scanLiteralArrayToken!private!scanning! !
!SmalltalkScanner categoriesFor: #scanLiteralCharacter!private!scanning! !
!SmalltalkScanner categoriesFor: #scanLiteralString!private!scanning! !
!SmalltalkScanner categoriesFor: #scanName!private!scanning! !
!SmalltalkScanner categoriesFor: #scanNameSpaceName!private!scanning! !
!SmalltalkScanner categoriesFor: #scanNumber!private!scanning! !
!SmalltalkScanner categoriesFor: #scanOptimized!private!scanning! !
!SmalltalkScanner categoriesFor: #scanPatternVariable!private!scanning! !
!SmalltalkScanner categoriesFor: #scanQualifiedReference!private!scanning! !
!SmalltalkScanner categoriesFor: #scanSpecialCharacter!private!scanning! !
!SmalltalkScanner categoriesFor: #scanStringSymbol!private!scanning! !
!SmalltalkScanner categoriesFor: #scanSymbol!private!scanning! !
!SmalltalkScanner categoriesFor: #scanToken!accessing!public! !
!SmalltalkScanner categoriesFor: #separatorsInLiterals:!accessing!private! !
!SmalltalkScanner categoriesFor: #step!operations!private! !
!SmalltalkScanner categoriesFor: #stripComment!public!scanning! !
!SmalltalkScanner categoriesFor: #stripSeparators!private!scanning! !
!SmalltalkScanner categoriesFor: #unterminatedComment:!error handling!private! !
!SmalltalkScanner categoriesFor: #unterminatedQualifiedRef!error handling!private! !
!SmalltalkScanner categoriesFor: #unterminatedString!error handling!private! !

!SmalltalkScanner class methodsFor!

classificationTable
	^ClassificationTable!

initialize
	self initializeClassificationTable!

initializeChars: aCollectionOfCharacters to: aSymbol 
	aCollectionOfCharacters do: [:c | ClassificationTable at: c asInteger put: aSymbol]!

initializeClassificationTable
	PatternVariableCharacter := $`.
	ClassificationTable := Array new: 255.
	"#2130 ANSI Smalltalk allows only the English alphabet and underscore as letters in identifiers"
	self initializeChars: '_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' to: #alphabetic.
	self initializeChars: '01234567890' to: #digit.
	self initializeChars: '!!%&*+,-/<=>?@\~|' to: #binary.
	self initializeChars: '().:;[]^' to: #special.
	self initializeChars: (Character byteCharacterSet select: [:each | each isSeparator]) to: #separator!

isSelector: aSymbol 
	| scanner token |
	scanner := self basicNew.
	scanner on: (ReadStream on: aSymbol asString).
	scanner errorBlock: [:err | ^false].
	scanner step.
	token := scanner scanAnySymbol.
	token isLiteralToken ifFalse: [^false].
	token value isEmpty ifTrue: [^false].
	^scanner atEnd!

isVariable: aString 
	| scanner token |
	aString isString ifFalse: [^false].
	aString isEmpty ifTrue: [^false].
	(self classificationTable at: aString first asInteger) == #alphabetic ifFalse: [^false].
	scanner := self basicNew.
	scanner on: (ReadStream on: aString asString).
	scanner errorBlock: [:err | ^false].
	scanner step.
	token := scanner scanIdentifierOrKeyword.
	token isKeyword ifTrue: [^false].
	^scanner atEnd!

on: aStream 
	| scanner |
	scanner := self basicNew on: aStream.
	scanner
		step;
		stripSeparators.
	^scanner!

on: aStream errorBlock: aBlock 
	| scanner |
	scanner := self basicNew on: aStream.
	scanner
		errorBlock: aBlock;
		step;
		stripSeparators.
	^scanner!

on: aStream errorHandler: parseErrorHandler 
	| scanner |
	scanner := self basicNew on: aStream.
	scanner
		errorHandler: parseErrorHandler;
		step;
		stripSeparators.
	^scanner!

patternVariableCharacter
	^PatternVariableCharacter! !
!SmalltalkScanner class categoriesFor: #classificationTable!accessing!public! !
!SmalltalkScanner class categoriesFor: #initialize!initializing!public! !
!SmalltalkScanner class categoriesFor: #initializeChars:to:!initializing!private! !
!SmalltalkScanner class categoriesFor: #initializeClassificationTable!initializing!private! !
!SmalltalkScanner class categoriesFor: #isSelector:!public!testing! !
!SmalltalkScanner class categoriesFor: #isVariable:!public!testing! !
!SmalltalkScanner class categoriesFor: #on:!instance creation!public! !
!SmalltalkScanner class categoriesFor: #on:errorBlock:!instance creation!public! !
!SmalltalkScanner class categoriesFor: #on:errorHandler:!instance creation!public! !
!SmalltalkScanner class categoriesFor: #patternVariableCharacter!accessing!public! !

