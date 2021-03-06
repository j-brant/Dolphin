"Filed out from Dolphin Smalltalk XP"!

StParseNodeVisitor subclass: #RBSourceFormatter
	instanceVariableNames: 'codeStream lineStart indent'
	classVariableNames: 'MaxLineLength PeriodsAtEndOfMethod'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBSourceFormatter guid: (GUID fromString: '{9FD4DE67-3C87-4496-87B9-7C3CF9655F65}')!
RBSourceFormatter comment: 'RBSourceFormatter is the abstract class of <StParseNodeVisitor>s that pretty print Smalltalk source code.

Instance Variables:
	codeStream	<PositionableStream>	the stream we are writing our output to
	lineStart		<Integer>	the position of the character that started the current line. This is used for calculating the line length.
	indent		<Integer>	how many times are we indenting a new line -- indents are normally tabs but could be any whitespace string
'!
!RBSourceFormatter categoriesForClass!Refactory-ParseTree Matching! !
!RBSourceFormatter methodsFor!

acceptExternalArgTypeNode: anStExternalArgTypeNode
	| typeOrdinal |
	typeOrdinal := anStExternalArgTypeNode typeOrdinal.
	codeStream nextPutAll: (ExternalDescriptor nameOf: typeOrdinal type: anStExternalArgTypeNode structClass).
	anStExternalArgTypeNode indirections timesRepeat: [codeStream nextPut: $*].!

acceptExternalCallNode: aStExternalCallNode 
	codeStream nextPut: $<.
	aStExternalCallNode isOverlapped ifTrue: [codeStream nextPutAll: 'overlap '].
	aStExternalCallNode isVirtual ifTrue: [codeStream nextPutAll: 'virtual '].
	codeStream
		nextPutAll: (ExternalDescriptor nameOfConvention: aStExternalCallNode callingConvention);
		space.
	self visitNode: aStExternalCallNode returnType.
	codeStream space.
	self formatExternalCallName: aStExternalCallNode.
	aStExternalCallNode argumentTypes do: 
			[:each | 
			codeStream space.
			self visitNode: each].
	codeStream nextPut: $>.
	self newLine!

acceptMethodNode: aMethodNode 
	self formatMethodPatternFor: aMethodNode.
	self formatMethodBodyFor: aMethodNode!

acceptPrimitiveNode: anStPrimitiveNode 
	codeStream
		nextPutAll: '<primitive: ';
		print: anStPrimitiveNode primitiveIndex;
		nextPut: $>.
	self newLine!

acceptVariableNode: aVariableNode 
	codeStream nextPutAll: aVariableNode name!

format: aNode
	self visitNode: aNode.
	^codeStream contents!

formatExternalCallName: aStExternalCallNode 
	| name |
	name := aStExternalCallNode nameOrOrdinal.
	(name isInteger or: [Symbol isLiteralSymbol: name]) 
		ifTrue: [codeStream display: name]
		ifFalse: [codeStream print: name]!

formatMethodBodyFor: aMethodNode 
	^self subclassResponsibility!

formatMethodPatternFor: aMethodNode 
	^self subclassResponsibility!

formatTagFor: aMethodNode 
	#rbFix.	"The Dolphin parser is enhanced to actually parse primitives into nodes, so we must visit those nodes"
	"aMethodNode primitiveSources do:
			[:each | 
			codeStream nextPutAll: each.
			self newLine]"
	aMethodNode tag ifNotNil: [:tag | self visitNode: tag]!

indent: anInteger
	indent := anInteger!

indent: anInteger around: aBlock 
	indent := indent + anInteger.
	^aBlock ensure: [indent := indent - anInteger]!

initialize
	super initialize.
	indent := lineStart := 0.
	codeStream := WriteStream on: (String new: 256)!

newLine
	^self subclassResponsibility!

space
	codeStream space! !
!RBSourceFormatter categoriesFor: #acceptExternalArgTypeNode:!public!visitor/double dispatching! !
!RBSourceFormatter categoriesFor: #acceptExternalCallNode:!public!visitor/double dispatching! !
!RBSourceFormatter categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!RBSourceFormatter categoriesFor: #acceptPrimitiveNode:!public!visitor/double dispatching! !
!RBSourceFormatter categoriesFor: #acceptVariableNode:!public!visitor/double dispatching! !
!RBSourceFormatter categoriesFor: #format:!operations!public! !
!RBSourceFormatter categoriesFor: #formatExternalCallName:!formatting!private! !
!RBSourceFormatter categoriesFor: #formatMethodBodyFor:!formatting!private! !
!RBSourceFormatter categoriesFor: #formatMethodPatternFor:!formatting!private! !
!RBSourceFormatter categoriesFor: #formatTagFor:!formatting!private! !
!RBSourceFormatter categoriesFor: #indent:!formatting!private! !
!RBSourceFormatter categoriesFor: #indent:around:!formatting!private! !
!RBSourceFormatter categoriesFor: #initialize!initializing!private! !
!RBSourceFormatter categoriesFor: #newLine!formatting!private! !
!RBSourceFormatter categoriesFor: #space!formatting!private! !

!RBSourceFormatter class methodsFor!

initialize
	"
		self initialize
	"

	self maxLineLength: 100.
	self periodsAtEndOfMethod: true!

maxLineLength
	^MaxLineLength!

maxLineLength: anInteger 
	MaxLineLength := anInteger!

periodsAtEndOfMethod
	"Answer whether the methods should be formatted with a period at the end of the last
	statement in the method or not - syntactically the period is not required, but it makes it
	easier to add new statements at the end of the method."

	^PeriodsAtEndOfMethod!

periodsAtEndOfMethod: aBoolean 
	PeriodsAtEndOfMethod := aBoolean! !
!RBSourceFormatter class categoriesFor: #initialize!initializing!public! !
!RBSourceFormatter class categoriesFor: #maxLineLength!public!settings! !
!RBSourceFormatter class categoriesFor: #maxLineLength:!public!settings! !
!RBSourceFormatter class categoriesFor: #periodsAtEndOfMethod!public! !
!RBSourceFormatter class categoriesFor: #periodsAtEndOfMethod:!public! !

