"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #PushUpMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushUpMethodTest guid: (GUID fromString: '{890376AA-D3A6-46BB-BADD-A03B14FFD1CD}')!
PushUpMethodTest comment: ''!
!PushUpMethodTest categoriesForClass!Refactory-Testing! !
!PushUpMethodTest methodsFor!

testPushUpAndCopyDown
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model 
		defineClass: 'SomeClass subclass: #SomeSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'SomeSubclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'SomeSubclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self executeRefactoring: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: class).
	self assert: (class superclass parseTreeFor: #yourself) 
				= (RBParser parseMethod: 'yourself ^1').
	self deny: (class directlyDefinesMethod: #yourself).
	class := model classNamed: #Foo2.
	self assert: (class directlyDefinesMethod: #yourself).
	self assert: (class parseTreeFor: #yourself) 
				= ((model classNamed: #Object) parseTreeFor: #yourself)!

testPushUpClassMethod
	| class |
	class := model classNamed: #Object.
	class addClassVariable: #Foo.
	class metaclass compile: 'foo ^Foo' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#foo)
				from: class metaclass)!

testPushUpMethodWithCopyOverriddenMethodsDown
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := PushUpMethodRefactoring pushUp: #(#isComposite)
						from: CompositeLintRuleTest.
			self executeRefactoring: refactoring].
	self 
		assert: ((refactoring model classNamed: #BasicLintRuleTest) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^false').
	self 
		assert: ((refactoring model classNamed: ('Foo' , 'LintRuleTest') asSymbol) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^false').
	self 
		assert: ((refactoring model classNamed: #LintRuleTest) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^true').
	self deny: ((refactoring model classNamed: #CompositeLintRuleTest) 
				directlyDefinesMethod: #isComposite)!

testPushUpReferencesInstVar
	self shouldFail: (PushUpMethodRefactoring pushUp: #(#checkClass:)
				from: BasicLintRuleTest)!

testPushUpWithInvalidSuperSend
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Foo2) compile: 'yourself ^super yourself + 1'
		classified: #(#accessing).
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: class)!

testPushUpWithMethodThatCannotBePushedDown
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #SomeClass) compile: 'yourself ^54'
		classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: (model classNamed: #SomeClass))!

testPushUpWithSuperSendThatCannotBeCopiedDown
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #Object) compile: 'foo ^3' classified: #(#accessing).
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^super foo'
		classified: #(#accessing).
	model 
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(class := model classNamed: #Foo2) compile: 'foo ^1'
		classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#foo)
				from: class)! !
!PushUpMethodTest categoriesFor: #testPushUpAndCopyDown!public!tests! !
!PushUpMethodTest categoriesFor: #testPushUpClassMethod!failure tests!public! !
!PushUpMethodTest categoriesFor: #testPushUpMethodWithCopyOverriddenMethodsDown!public!tests! !
!PushUpMethodTest categoriesFor: #testPushUpReferencesInstVar!failure tests!public! !
!PushUpMethodTest categoriesFor: #testPushUpWithInvalidSuperSend!failure tests!public! !
!PushUpMethodTest categoriesFor: #testPushUpWithMethodThatCannotBePushedDown!failure tests!public! !
!PushUpMethodTest categoriesFor: #testPushUpWithSuperSendThatCannotBeCopiedDown!failure tests!public! !

