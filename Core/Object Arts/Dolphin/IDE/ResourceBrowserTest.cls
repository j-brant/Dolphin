"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ResourceBrowserTest
	instanceVariableNames: 'resourceBrowser testClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceBrowserTest guid: (GUID fromString: '{8D888BA2-F5B7-402C-9BFF-E88B2CDE2FAB}')!
ResourceBrowserTest comment: ''!
!ResourceBrowserTest categoriesForClass!Unclassified! !
!ResourceBrowserTest methodsFor!

getShellResource
	^(ResourceIdentifier class: Shell) resource!

resourceBrowser
	^resourceBrowser!

resourceDisplayList
	^self resourceToolboxPresenter resourcesPresenter list!

resourceList
	^self resourceToolboxPresenter list!

resourceToolboxPresenter
	^self resourceBrowser resourceToolboxPresenter!

setUp
	super setUp.
	resourceBrowser := ResourceBrowser show.
	testClass := self class 
				subclass: #ResourceBrowserTestSampleClass
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: ''!

tearDown
	self resourceBrowser destroy.
	testClass removeFromSystem.
	super tearDown!

testAddRemoveResource
	| sampleResourceId |
	
	[sampleResourceId := ResourceIdentifier class: testClass.
	self resourceBrowser selectCategory: 'Misc'.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId).
	sampleResourceId assign: self getShellResource.
	self assert: (self resourceList includes: sampleResourceId).
	self assert: (self resourceDisplayList includes: sampleResourceId).
	testClass class removeSelector: sampleResourceId selector.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId)] 
			ensure: [testClass class removeSelector: sampleResourceId selector ifAbsent: []]!

testBasicContents
	self assert: self resourceList notEmpty.
	self assert: (self resourceList first isKindOf: ResourceIdentifier).
	self assert: self resourceList size > 100.
	self assert: (self resourceList includes: (ResourceIdentifier class: Shell)).
	self assert: (self resourceList includes: (ResourceIdentifier class: SystemBrowserShell))! !
!ResourceBrowserTest categoriesFor: #getShellResource!private!unit tests! !
!ResourceBrowserTest categoriesFor: #resourceBrowser!private!unit tests! !
!ResourceBrowserTest categoriesFor: #resourceDisplayList!private!unit tests! !
!ResourceBrowserTest categoriesFor: #resourceList!private!unit tests! !
!ResourceBrowserTest categoriesFor: #resourceToolboxPresenter!private!unit tests! !
!ResourceBrowserTest categoriesFor: #setUp!private!unit tests! !
!ResourceBrowserTest categoriesFor: #tearDown!private!unit tests! !
!ResourceBrowserTest categoriesFor: #testAddRemoveResource!public!unit tests! !
!ResourceBrowserTest categoriesFor: #testBasicContents!public!unit tests! !

