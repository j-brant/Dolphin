"Filed out from Dolphin Smalltalk X6.1"!

Presenter subclass: #InplaceTextEditor
	instanceVariableNames: 'textRectangle minExtent maxCharWidth confirmed ownerView validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InplaceTextEditor guid: (GUID fromString: '{772412AA-7CA7-476C-B034-E5397984A86D}')!
InplaceTextEditor comment: 'InplaceTextEditor is a special kind of "prompter" that appears as an in-place text edit control over the text being edited. It behaves like a modal dialog, in that control is not returned to the called until the in-place edit has been committed or cancelled. This makes for an easier programming model than the alternative of a modeless view shown from the activating command, and delayed response to events when a modeless view is cancelled/committed to complete the command. However InplaceTextEditor is not actually a true dialog, because if it were then when shown it would have the undesirable effect of de-activating the owning top-level window while the editor is open.

The in-place text editor is shown with an initial size that is sufficient to display the existing edited text (with the edit controls adornments such as borders and margins), plus sufficient extra space for any character in the current font to be typed. As more characters are typed, the edit box grows dynamically. If characters are deleted then the edit control shrinks, but never below the initial size.

The edit can be committed by pressing the ENTER key, or by clicking over some other window so the control loses focus. This causes the InplaceTextEditor window to close, and control is returned to the caller with a return value that is the edited text. The edit can be cancelled by pressing the ESCape key, in which case the InplaceTextEditor window is closed, and control is returned with a nil return value.

A validation block can be specified which controls whether the ability to commit an edit is enabled. If the validation block answers false, then the ENTER key will result in an error beep, and clicking elsewhere so the in-place edit loses focus (and is therefore closed) will be treated as cancelling the edit rather than committing it. Just like a normal <Prompter> the initial value has no special significance, and whether or not the original value can be committed without making any changes is entirely controlled by the validation block. By default the validation block will accept any input.

Instance Variables:
	textRectangle		<Rectangle>. The rectangle of the text being edited, specified in the co-ordinates of the ownerView.
	minExtent			<Point>. The minimum extent to which the in-place edit control is allowed to shrink. Initialised to the initial size required to allow editing of the original text.
	maxCharWidth		<integer>. The maximm width of a character from the font of the text being edited.
	confirmed			<boolean>. Whether or not the edit has been comitted.
	ownerView		<View>. The view for which text is being edited in place. Defaults to the view with focus.
	validationBlock		<monadicValuable> used to validate the input when a commit action is attempted.
'!
!InplaceTextEditor categoriesForClass!MVP-Presenters! !
!InplaceTextEditor methodsFor!

answer
	"Answer the model if the receiver was confirmed (with #apply, #ok) or nil otherwise"

	^self isConfirmed ifTrue: [self model value]!

apply
	"Apply the changes cached in the receiver back to the original model. This can be used to
	dynamically see the effect of the changes without closing the dialog. More often it is sent
	by the #ok method just before closing the associated view."

	| focus |

	"First ensure that any changes cached in the view with focus (if any) are flushed"
	focus := View focus.
	focus isNil ifFalse: [focus updateModel].

	self model apply.
	confirmed := true.!

bufferClass
	^ValueBuffer!

bufferedModelFor: aSubjectValueModel 
	"Private - Answers a buffer suitable for the receiver on aSubjectValueModel. This will become the
	actual model to which the receiver is bound."

	^(self bufferClass subject: aSubjectValueModel asValue) comparisonPolicy: SearchPolicy equality!

cancel
	"Close the receiver without applying the changes back to the original model"

	self view isTextModified: false.
	self view close!

createSchematicWiring
	self 
		when: #focusLost
		send: #onFocusLost
		to: self.
	self 
		when: #textChanged
		send: #onTextChanged
		to: self.
	^super createSchematicWiring!

createView: aResourceNameString 
	"Private - Creates and connects a view for the receiver from the resource identified by
	aResourceNameString. Answers the new view created"

	| contextView |
	contextView := parentPresenter isNil ifTrue: [View focus] ifFalse: [parentPresenter view].
	self view: (self class loadViewResource: aResourceNameString inContext: contextView).
	^self view!

editBox
	"Private - Answer the TextEdit control"

	^self view!

findDetails
	^nil!

font: aFont 
	self view font: aFont.
	maxCharWidth := self view canvas textMetrics tmMaxCharWidth!

implicitBorder
	"Private - Widths of the implicit border on an edit control that has to be added to the
	calculated extent."

	^1@1 corner: 1@1!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self ownerView: View focus.
	confirmed := false.
	validationBlock := [:replyString | true]!

isConfirmed
	"Answer true if the receiver has been confirmed and changes have been applied to the
	associated model. Can be sent after the in-place edit has closed to determine if the edit
	was committed rather than cancelled."

	^confirmed!

isInputValid
	^(self validationBlock value: self editBox text) == true!

model: aValueModel 
	"Set the model of the receiver to be aValueModel. Register with it's #valueChanged event"

	| actualModel |
	actualModel := aValueModel notNil ifTrue: [self bufferedModelFor: aValueModel].
	super model: actualModel.
	aValueModel 
		when: #valueChanged
		send: #onValueChanged
		to: self!

ok
	"Close the receiver and apply the changes cached in the receiver back to the model"

	self apply.
	self view close.
!

onFocusLost
	"Private - If the user clicks outside the in-place edit box, then treat as a committed edit
	if the value has changed and is valid, otherwise treat as cancel."

	"If focus is lost because the window is closing then don't do anything"

	self view isWindowVisible ifTrue: [self isInputValid ifTrue: [self ok] ifFalse: [self cancel]]!

onGetCursor: aSymbol 
	"The named area of the view associated with the receiver has been hit. Answer the
	appropriate mouse cursor or nil to accept the default."

	^Cursor iBeam!

onKeyTyped: aKeyEvent 
	aKeyEvent code == VK_ESCAPE 
		ifTrue: 
			[self commandPolicy route: (CommandDescription command: #cancel).
			^0].
	aKeyEvent code == VK_RETURN 
		ifTrue: 
			[self commandPolicy route: (CommandDescription command: #ok).
			^0].
	^super onKeyTyped: aKeyEvent!

onTextChanged
	self resizeToFit!

onValueChanged
	"The value held by the receiver's model has changed. The default is to trigger a
	#valueChanged event off the receiver"

	self trigger: #valueChanged!

onViewOpened
	super onViewOpened.
	self setInitialFocus!

ownerView
	^ownerView!

ownerView: aView 
	ownerView := aView!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the
	<CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

requiredExtent
	| min preferred borders |
	borders := self implicitBorder.
	preferred := self editBox calculateExtent 
				+ ((maxCharWidth + (borders left + borders right)) @ (borders top + borders bottom)).
	min := minExtent ifNil: [minExtent := preferred].
	^min max: preferred!

resizeToFit
	self view extent: self requiredExtent!

runModalInProcessLoop
	^SessionManager inputState loopWhile: [self isOpen]!

setInitialFocus
	self editBox setFocus!

showModal
	"Show the receiver's view as a modal 'dialog'. Answer the revised text, or the original text if cancelled."

	self showModalView.
	^self answer!

showModalView
	
	["Adjust the position of the dialog to be over the edited text."
	| offset preferred pos |
	(self editBox)
		selectAll;
		setMarginWidths: #(0 0).
	minExtent := nil.
	self resizeToFit.
	preferred := self editBox calculateExtent.
	offset := (preferred - textRectangle extent) // 2 + self implicitBorder left.
	pos := textRectangle origin - offset.
	(self view)
		position: pos;
		layout;
		show.
	self runModalInProcessLoop] 
			ensure: [self view basicDestroy]!

textRectangle: aRectangle 
	"Set the rectangle of the text being edited in-place. N.B. The Rectangle is expected to be
	in the co-ordinates of the owner view (the parent with focus on whose behalf the receiver is
	to edit text)."

	textRectangle := aRectangle!

validationBlock
	^validationBlock!

validationBlock: aBlock 
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the
	current reply text as its argument, and is expected to answer whether it is valid. The
	ability to commit the edit is not enabled until the validationBlock answers true."

	validationBlock := aBlock!

value
	"Answer the model value of the receiver"

	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject. The change will not be flushed back to
	the original subject model until #apply is received"

	self model value: anObject.! !
!InplaceTextEditor categoriesFor: #answer!accessing!public! !
!InplaceTextEditor categoriesFor: #apply!commands!public! !
!InplaceTextEditor categoriesFor: #bufferClass!accessing!private! !
!InplaceTextEditor categoriesFor: #bufferedModelFor:!accessing!private! !
!InplaceTextEditor categoriesFor: #cancel!commands!public! !
!InplaceTextEditor categoriesFor: #createSchematicWiring!initializing!public! !
!InplaceTextEditor categoriesFor: #createView:!operations!private! !
!InplaceTextEditor categoriesFor: #editBox!helpers!private! !
!InplaceTextEditor categoriesFor: #findDetails!public!searching & replacing! !
!InplaceTextEditor categoriesFor: #font:!initializing!public! !
!InplaceTextEditor categoriesFor: #implicitBorder!constants!private! !
!InplaceTextEditor categoriesFor: #initialize!initializing!private! !
!InplaceTextEditor categoriesFor: #isConfirmed!public!testing! !
!InplaceTextEditor categoriesFor: #isInputValid!private!testing! !
!InplaceTextEditor categoriesFor: #model:!accessing!public! !
!InplaceTextEditor categoriesFor: #ok!commands!public! !
!InplaceTextEditor categoriesFor: #onFocusLost!event handling!private! !
!InplaceTextEditor categoriesFor: #onGetCursor:!event handling!public! !
!InplaceTextEditor categoriesFor: #onKeyTyped:!event handling!private! !
!InplaceTextEditor categoriesFor: #onTextChanged!event handling!private! !
!InplaceTextEditor categoriesFor: #onValueChanged!event handling!public! !
!InplaceTextEditor categoriesFor: #onViewOpened!event handling!private! !
!InplaceTextEditor categoriesFor: #ownerView!accessing!public! !
!InplaceTextEditor categoriesFor: #ownerView:!accessing!public! !
!InplaceTextEditor categoriesFor: #queryCommand:!commands!private! !
!InplaceTextEditor categoriesFor: #requiredExtent!helpers!private! !
!InplaceTextEditor categoriesFor: #resizeToFit!helpers!private! !
!InplaceTextEditor categoriesFor: #runModalInProcessLoop!helpers!private! !
!InplaceTextEditor categoriesFor: #setInitialFocus!operations!public! !
!InplaceTextEditor categoriesFor: #showModal!public!realizing/unrealizing! !
!InplaceTextEditor categoriesFor: #showModalView!helpers!private! !
!InplaceTextEditor categoriesFor: #textRectangle:!initializing!public! !
!InplaceTextEditor categoriesFor: #validationBlock!accessing!public! !
!InplaceTextEditor categoriesFor: #validationBlock:!accessing!public! !
!InplaceTextEditor categoriesFor: #value!accessing!public! !
!InplaceTextEditor categoriesFor: #value:!accessing!public! !

!InplaceTextEditor class methodsFor!

createOn: aValueHolder 
	^(super createOn: aValueHolder)
		onViewOpened;
		yourself!

defaultModel
	^String new!

icon
	"Answers an Icon that can be used to represent this class"

	^TextEdit icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.TextEdit)  98 16 0 0 98 2 8 1149304832 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 721158 ##(Smalltalk.SystemColor)  11 0 1543 0 0 0 416 0 8 4294903569 852486 ##(Smalltalk.NullConverter)  0 8 '' 65 983302 ##(Smalltalk.MessageSequence)  202 208 98 5 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3359 21 786 191 41 416 722 8 #text: 98 1 8 'Text to be edited' 416 722 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 722 8 #isTextModified: 98 1 32 416 722 8 #setMarginWidths: 98 1 98 2 5 5 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 238 6 0 0 30 0 0 0] 98 0 786 193 193 0 27 )! !
!InplaceTextEditor class categoriesFor: #createOn:!public! !
!InplaceTextEditor class categoriesFor: #defaultModel!models!public! !
!InplaceTextEditor class categoriesFor: #icon!constants!public! !
!InplaceTextEditor class categoriesFor: #resource_Default_view!public!resources-views! !

