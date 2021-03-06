"Filed out from Dolphin Smalltalk X6"!

ClassBrowserPlugin subclass: #ClassCommentPlugin
	instanceVariableNames: 'textPresenter'
	classVariableNames: 'TextStyles WordWrap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassCommentPlugin guid: (GUID fromString: '{9BBB729C-F516-492E-B991-7AD0C238A37F}')!
ClassCommentPlugin comment: 'ClassCommentPlugin is the <classBrowserPlugin> that displays the comment associated with a class, if any. The icon associated with the plugin''s tab in the class browser is updated to indicate whether or not a class is currently commented so that one can see at a glance whether any documentation is available for a class without having to switch to the plugin''s page.

Instance Variables:
	textPresenter		<SmalltalkWorkspace> used to display and edit the class comment.'!
!ClassCommentPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!ClassCommentPlugin methodsFor!

accept
	"Save the class comment."

	textPresenter isModified: false.
	self browser selectedClass comment: textPresenter plainText!

applyOptions
	super applyOptions.
	self setWordWrap.
	self setTextStyles.
	self refreshIcon!

createComponents
	"Private - Create the presenters contained by the receiver"

	textPresenter := self add: Smalltalk developmentSystem workspaceClass new name: 'comment'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #classSelected
			send: #onBrowserClassSelected
			to: self;
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self.
	self model model 
		when: #classCommented:
		send: #onClassCommented:
		to: self
	"		when: #classUpdated:
			send: #onClassUpdated:
			to: self;"!

defaultHelpId
	^10747!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Class comment'!

icon
	^textPresenter textLength > 0 ifTrue: [self class icon] ifFalse: [self class grayedIcon]!

isModified
	^textPresenter isModified!

onBrowserClassSelected
	"Event handler for a class being selected within the receiver's associated browser. "

	| selectedClass |
	selectedClass := self browser selectedClass.
	textPresenter
		text: (selectedClass isNil ifTrue: [String new] ifFalse: [selectedClass comment]);
		evaluationContext: self browser selectedClass;
		searchEnvironment: self browser searchEnvironment.
	self refreshIcon!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	(self isCurrentCard and: [self browser hasMethodSelected]) 
		ifTrue: [self browser ensureSourceVisible]!

onClassCommented: aClass 
	"Private - The comment of a class within the receiver has been changed. 
	Refresh the comment pane if it is the selected class."

	| class |
	class := self browser actualClass.
	(class isNil or: [class instanceClass ~~ aClass instanceClass]) ifTrue: [^self].
	self updateComment: aClass comment!

promptToSaveClassChanges: aSelectionChangingEvent 
	"Sent by the browser when its class selection is about to change. This is an opportunity for
	the plugin to prompt to save changes, etc. If the selection should not be changed, then the
	value of the out parameter, aBooleanValue, should be set to false. Also answers whether the
	selection change can continue."

	textPresenter prompt: 'class comment' toSaveChanges: aSelectionChangingEvent.
	^aSelectionChangingEvent value!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#accept == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self browser hasClassSelected.
			^true].
	^super queryCommand: aCommandQuery!

refreshIcon
	self view arrangement: self!

setTextStyles
	textPresenter view textStyles: self class textStyles!

setWordWrap
	textPresenter view wordWrap: self class wordWrap!

updateComment: aString 
	| class event |
	class := self browser actualClass.
	event := (SelectionChangingEvent forSource: self browser)
				oldSelection: class;
				newSelection: class;
				yourself.
	(self promptToSaveClassChanges: event) ifTrue: [textPresenter text: aString].
	self refreshIcon! !
!ClassCommentPlugin categoriesFor: #accept!commands!public! !
!ClassCommentPlugin categoriesFor: #applyOptions!options!private! !
!ClassCommentPlugin categoriesFor: #createComponents!initializing!private! !
!ClassCommentPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!ClassCommentPlugin categoriesFor: #defaultHelpId!constants!public! !
!ClassCommentPlugin categoriesFor: #displayOn:!displaying!public! !
!ClassCommentPlugin categoriesFor: #icon!accessing!public! !
!ClassCommentPlugin categoriesFor: #isModified!public!testing! !
!ClassCommentPlugin categoriesFor: #onBrowserClassSelected!event handling!private! !
!ClassCommentPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!ClassCommentPlugin categoriesFor: #onClassCommented:!event handling!private! !
!ClassCommentPlugin categoriesFor: #promptToSaveClassChanges:!helpers!public! !
!ClassCommentPlugin categoriesFor: #queryCommand:!commands!private! !
!ClassCommentPlugin categoriesFor: #refreshIcon!operations!private! !
!ClassCommentPlugin categoriesFor: #setTextStyles!helpers!private! !
!ClassCommentPlugin categoriesFor: #setWordWrap!helpers!private! !
!ClassCommentPlugin categoriesFor: #updateComment:!helpers!private! !

!ClassCommentPlugin class methodsFor!

defaultTextStyles
	^(Set new)
		add: ((ScintillaTextStyle new)
					name: #normal;
					forecolor: Color darkGreen;
					yourself);
		add: ((ScintillaTextStyle name: #indentGuide)
					forecolor: Color gray;
					yourself);
		yourself!

grayedIcon
	"Answer the <Icon> to be used on the class comment tab when there is no class comment."

	^Icon fromFile: 'GrayedClassComment.ico'!

icon
	"Answer an <Icon> that can be used to represent this class."

	^Icon fromFile: 'ClassComment.ico'!

initialize
	WordWrap := true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #wordWrap);
		add: SmalltalkWorkspace textStylesAspect;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 416 98 2 8 1176572228 262145 576 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 498 528 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 15 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 738 0 16 98 8 786 1 818 8 #undo 8 '&Undo' 1 1 0 0 0 882 4097 786 1 818 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 786 1 818 8 #copySelection 8 '&Copy' 1 1 0 0 0 786 1 818 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 786 1 818 8 #clearSelection 8 'De&lete' 1 1 0 0 0 882 4097 786 1 818 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 1 0 0 0 0 0 786 1 818 8 #clear 8 'Clea&r' 1 1 0 0 0 882 4097 786 1 818 8 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 786 1 818 8 #displayIt 8 '&Display It' 1 1 0 0 0 786 1 818 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 786 1 818 8 #inspectIt 8 '&Inspect It' 1 1 1522 0 16 1568 8 'BasicInspector.ico' 1616 0 0 786 1 818 8 #debugIt 8 'Deb&ug It' 1 1 1522 0 16 1568 8 'Debugger.ico' 1616 0 0 882 4097 786 1 818 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 786 1 818 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 882 4097 738 0 16 98 2 786 2097153 818 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 786 1 818 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 576 0 8 4294905987 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 2 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 2400 0 0 0 234 256 98 2 1 2432 1245510 1 ##(Smalltalk.NullScintillaStyler)  2400 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 2594 33554471 576 8 #circle 202 208 98 0 0 63 9215 0 0 0 0 2594 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 2368 0 0 0 0 1 0 234 256 98 4 8 #Warning 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 576 33554465 3 32 2800 0 8 #Error 2818 19 576 33554459 3 32 2848 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 9 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 3010 701 501 576 2946 8 #contextMenu: 98 1 752 576 2946 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 576 2946 8 #isTextModified: 98 1 32 576 2946 8 #modificationEventMask: 98 1 9215 576 2946 8 #wordWrap: 98 1 16 576 2946 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 576 1 3 32 1 3394 3 576 1 1 32 67108863 3394 5 576 1 1 32 1 576 2946 8 #indentationGuides: 98 1 0 576 2946 8 #tabIndents: 98 1 16 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 3010 193 193 0 27 234 256 98 2 576 8 'comment' 0 2882 202 208 98 1 2946 2976 98 2 3010 3359 21 3010 701 501 416 3554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 237 7 0 0 4 1 0 0] 98 1 576 3616 0 27 )!

textStyles
	TextStyles isNil ifTrue: [TextStyles := self defaultTextStyles].
	^TextStyles!

wordWrap
	"Answer whether word wrap should be enabled in new instances of the receiver."

	^WordWrap!

wordWrap: aBoolean 
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrap == aBoolean ifTrue: [^self].
	WordWrap := aBoolean.
	self allSubinstances do: [:each | each setWordWrap]! !
!ClassCommentPlugin class categoriesFor: #defaultTextStyles!constants!public! !
!ClassCommentPlugin class categoriesFor: #grayedIcon!constants!public! !
!ClassCommentPlugin class categoriesFor: #icon!constants!public! !
!ClassCommentPlugin class categoriesFor: #initialize!initializing!public! !
!ClassCommentPlugin class categoriesFor: #publishedAspects!development!public! !
!ClassCommentPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassCommentPlugin class categoriesFor: #textStyles!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap:!accessing!options!public! !

