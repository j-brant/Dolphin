"Filed out from Dolphin Smalltalk XP"!

ParseTreeSearcher subclass: #ParseTreeRewriter
	instanceVariableNames: 'tree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ParseTreeRewriter guid: (GUID fromString: '{E902BFFE-805D-4946-B0EA-0E7501C75C73}')!
ParseTreeRewriter comment: 'ParseTreeRewriter walks over and transforms its BRProgramNode (tree). If the tree is modified, then answer is set to true, and the modified tree can be retrieved by the #tree method.

Instance Variables:
	tree	<BRProgramNode>	the parse tree we''re transforming'!
!ParseTreeRewriter categoriesForClass!Refactory-ParseTree Matching! !
!ParseTreeRewriter methodsFor!

acceptAssignmentNode: anAssignmentNode 
	anAssignmentNode variable: (self visitNode: anAssignmentNode variable).
	anAssignmentNode value: (self visitNode: anAssignmentNode value)!

acceptBlockNode: aBlockNode 
	aBlockNode arguments: (self visitArguments: aBlockNode arguments).
	aBlockNode body: (self visitNode: aBlockNode body)!

acceptCascadeNode: aCascadeNode 
	| newMessages notFound |
	newMessages := OrderedCollection new: aCascadeNode messages size.
	notFound := OrderedCollection new: aCascadeNode messages size.
	aCascadeNode messages do: 
			[:each | 
			| newNode |
			newNode := self performSearches: searches on: each.
			newNode isNil 
				ifTrue: 
					[newNode := each.
					notFound add: newNode].
			newNode isMessage 
				ifTrue: [newMessages add: newNode]
				ifFalse: 
					[newNode isCascade 
						ifTrue: [newMessages addAll: newNode messages]
						ifFalse: 
							[Transcript
								show: 'Cannot replace message node inside of cascaded node with non-message node.';
								cr.
							newMessages add: each]]].
	notFound size == aCascadeNode messages size 
		ifTrue: 
			[| receiver |
			receiver := self visitNode: aCascadeNode messages first receiver.
			newMessages do: [:each | each receiver: receiver]].
	notFound 
		do: [:each | each arguments: (each arguments collect: [:arg | self visitNode: arg])].
	aCascadeNode messages: newMessages!

acceptLiteralArrayNode: aRBArrayLiteralNode 
	aRBArrayLiteralNode contents: (aRBArrayLiteralNode contents 
				collect: [:each | self visitNode: each])!

acceptMessageNode: aMessageNode 
	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode 
		arguments: (aMessageNode arguments collect: [:each | self visitNode: each])!

acceptMethodNode: aMethodNode 
	aMethodNode arguments: (self visitArguments: aMethodNode arguments).
	aMethodNode body: (self visitNode: aMethodNode body)!

acceptOptimizedNode: anOptimizedNode 
	anOptimizedNode body: (self visitNode: anOptimizedNode body)!

acceptReturnNode: aReturnNode 
	aReturnNode value: (self visitNode: aReturnNode value)!

acceptSequenceNode: aSequenceNode 
	aSequenceNode 
		temporaries: (self visitArguments: aSequenceNode temporaries).
	aSequenceNode statements: (aSequenceNode statements 
				collect: [:each | self visitNode: each])!

executeTree: aParseTree 
	| oldContext |
	oldContext := context.
	context := RBSmallDictionary new.
	answer := false.
	tree := self visitNode: aParseTree.
	context := oldContext.
	^answer!

foundMatch
	answer := true!

lookForMoreMatchesInContext: oldContext 
	oldContext keysAndValuesDo: 
			[:key :value | 
			((key isKindOf: String) not and: [key recurseInto]) 
				ifTrue: 
					[oldContext at: key put: (value collect: [:each | self visitNode: each])]]!

replace: searchString with: replaceString 
	self addRule: (RBStringReplaceRule searchFor: searchString replaceWith: replaceString)!

replace: searchString with: replaceString when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replace: searchString withValueFrom: replaceBlock 
	self addRule: (RBBlockReplaceRule searchFor: searchString replaceWith: replaceBlock)!

replace: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (RBBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceArgument: searchString with: replaceString 
	self 
		addArgumentRule: (RBStringReplaceRule searchFor: searchString replaceWith: replaceString)!

replaceArgument: searchString with: replaceString when: aBlock 
	self addArgumentRule: (RBStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceArgument: searchString withValueFrom: replaceBlock 
	self 
		addArgumentRule: (RBBlockReplaceRule searchFor: searchString replaceWith: replaceBlock)!

replaceArgument: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addArgumentRule: (RBBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceMethod: searchString with: replaceString 
	self 
		addRule: (RBStringReplaceRule searchForMethod: searchString replaceWith: replaceString)!

replaceMethod: searchString with: replaceString when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceMethod: searchString withValueFrom: replaceBlock 
	self 
		addRule: (RBBlockReplaceRule searchForMethod: searchString replaceWith: replaceBlock)!

replaceMethod: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (RBBlockReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceTree: searchTree withTree: replaceTree 
	self addRule: (RBStringReplaceRule searchForTree: searchTree replaceWith: replaceTree)!

replaceTree: searchTree withTree: replaceTree when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchForTree: searchTree
				replaceWith: replaceTree
				when: aBlock)!

tree
	^tree!

visitArguments: aNodeCollection 
	^aNodeCollection collect: [:each | self visitArgument: each]! !
!ParseTreeRewriter categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptCascadeNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptLiteralArrayNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptReturnNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!ParseTreeRewriter categoriesFor: #executeTree:!accessing!public! !
!ParseTreeRewriter categoriesFor: #foundMatch!helpers!private! !
!ParseTreeRewriter categoriesFor: #lookForMoreMatchesInContext:!operations!private! !
!ParseTreeRewriter categoriesFor: #replace:with:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replace:with:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replace:withValueFrom:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replace:withValueFrom:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceArgument:with:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceArgument:with:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceMethod:with:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceMethod:with:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceTree:withTree:!public!replacing! !
!ParseTreeRewriter categoriesFor: #replaceTree:withTree:when:!public!replacing! !
!ParseTreeRewriter categoriesFor: #tree!accessing!public! !
!ParseTreeRewriter categoriesFor: #visitArguments:!public!visiting! !

!ParseTreeRewriter class methodsFor!

classVariable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self class'!

removeTemporaryNamed: aName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule replace: '| `@temps1 ' , aName , ' `@temps2 | ``@.Statements'
		with: '| `@temps1  `@temps2 | ``@.Statements'.
	^rewriteRule!

rename: varName to: newVarName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: varName with: newVarName.
	^rewriteRule!

rename: varName to: newVarName handler: aBlock 
	"Rename varName to newVarName, evaluating aBlock if there is a 
	temporary variable with the same name as newVarName. This 
	does not change temporary variables with varName."

	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: newVarName
			withValueFrom: 
				[:aNode | 
				aBlock value.
				aNode].
	^rewriteRule!

replace: code with: newCode in: aParseTree 
	^(self 
		replace: code
		with: newCode
		method: false)
		executeTree: aParseTree;
		tree!

replace: code with: newCode in: aParseTree onInterval: anInterval 
	| rewriteRule |
	rewriteRule := self new.
	^rewriteRule
		replace: code
			with: newCode
			when: [:aNode | aNode intersectsInterval: anInterval];
		executeTree: aParseTree;
		tree!

replace: code with: newCode method: aBoolean 
	| rewriteRule |
	rewriteRule := self new.
	aBoolean 
		ifTrue: [rewriteRule replaceMethod: code with: newCode]
		ifFalse: [rewriteRule replace: code with: newCode].
	^rewriteRule!

replaceLiteral: literal with: newLiteral 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule replaceTree: (RBLiteralNode value: literal)
		withTree: (RBLiteralNode value: newLiteral).
	^rewriteRule!

replaceLiteral: literal with: newLiteral inToken: literalToken 
	| value |
	value := literalToken realValue.
	(value class = literal class and: [value = literal]) 
		ifTrue: [^RBLiteralToken value: newLiteral].
	(value class == Array or: [value class == ByteArray]) 
		ifTrue: 
			[^RBLiteralToken 
				value: (literalToken value collect: 
							[:each | 
							self 
								replaceLiteral: literal
								with: newLiteral
								inToken: each])
				start: nil
				stop: nil].
	^literalToken!

replaceStatements: code with: newCode in: aParseTree onInterval: anInterval 
	| tree replaceStmt |
	tree := self buildTree: code method: false.
	tree isSequence ifFalse: [tree := RBSequenceNode statements: (Array with: tree)].
	tree temporaries: (Array with: (RBPatternVariableNode named: '`@temps')).
	tree addNodeFirst: (RBPatternVariableNode named: '`@.S1').
	tree lastIsReturn 
		ifTrue: [replaceStmt := '| `@temps | `@.S1. ^' , newCode]
		ifFalse: 
			[tree addNode: (RBPatternVariableNode named: '`@.S2').
			replaceStmt := '| `@temps | `@.S1. ' , newCode , '.
`@.S2'].
	^self 
		replace: tree formattedCode
		with: replaceStmt
		in: aParseTree
		onInterval: anInterval!

variable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self'!

variable: aVarName getter: getMethod setter: setMethod receiver: aString 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: aVarName , ' := ``@object' with: aString , ' ' , setMethod , ' ``@object';
		replace: aVarName with: aString , ' ' , getMethod.
	^rewriteRule! !
!ParseTreeRewriter class categoriesFor: #classVariable:getter:setter:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #removeTemporaryNamed:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #rename:to:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #rename:to:handler:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #replace:with:in:!accessing!public! !
!ParseTreeRewriter class categoriesFor: #replace:with:in:onInterval:!accessing!public! !
!ParseTreeRewriter class categoriesFor: #replace:with:method:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #replaceLiteral:with:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #replaceLiteral:with:inToken:!helpers!public! !
!ParseTreeRewriter class categoriesFor: #replaceStatements:with:in:onInterval:!accessing!public! !
!ParseTreeRewriter class categoriesFor: #variable:getter:setter:!instance creation!public! !
!ParseTreeRewriter class categoriesFor: #variable:getter:setter:receiver:!instance creation!public! !

