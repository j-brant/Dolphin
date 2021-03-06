"Filed out from Dolphin Smalltalk X6"!

Icon subclass: #Cursor
	instanceVariableNames: ''
	classVariableNames: 'AppStarting Arrow Cross Current DDCopy DDCopyScroll DDLink DDLinkScroll DDMove DDMoveScroll DDNone Hand Help IBeam No SizeAll SizeNESW SizeNS SizeNWSE SizeWE SplitHorizontal SplitVertical UpArrow Wait'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Cursor guid: (GUID fromString: '{87B4C640-026E-11D3-9FD7-00A0CC3E4A32}')!
Cursor comment: ''!
!Cursor categoriesForClass!Graphics-Tools! !
!Cursor methodsFor!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_CURSOR!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance. 
	I would have expected the User32 loadImage function to be capable of this but
	it does not appear to work for instance 0; the system. Hence this method 
	which tries the old way. Answers the loaded handle or nil if the load failed"

	^UserLibrary default loadCursor: hModule asParameter lpCursorName: identifier asParameter!

makeCurrent
	"Make the receiver become the current global cursor."

	self class current: self!

setCursor
	"Private - Set the receiver as the current Windows cursor. Answers the handle of the old
	cursor."

	^UserLibrary default setCursor: self asParameter!

showWhile: aBlock
	"Maintain the wait cursor while aBlock is executed, answering the result of the block.
	The actual cursor which was current is restored (rather than the one we think is Current)."

	| previous actual |
	previous := Current.
	Current := self.
	actual := self setCursor.
	^aBlock ensure: 
			[Current := previous.
			UserLibrary default setCursor: actual]! !
!Cursor categoriesFor: #imageType!constants!private! !
!Cursor categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !
!Cursor categoriesFor: #makeCurrent!operations!public! !
!Cursor categoriesFor: #setCursor!operations!private! !
!Cursor categoriesFor: #showWhile:!operations!public! !

!Cursor class methodsFor!

appStarting
	"Answer the instance that is the AppStarting cursor."

	AppStarting isNil ifTrue: [AppStarting := self fromSystemId: IDC_APPSTARTING].
	^AppStarting!

arrow
	"Answer the instance that is the Arrow cursor."

	Arrow isNil ifTrue: [Arrow := self fromSystemId: IDC_ARROW].
	^Arrow!

cross
	"Answer the instance that is the Cross cursor."

	Cross isNil ifTrue: [Cross := self fromSystemId: IDC_CROSS].
	^Cross!

current
	"Answers the current global cursor. This may be nil."

	^Current!

current: aCursorOrNil
	"Private - Set the current cursor to aCursorOrNil.
	Answers the previous current cursor (or nil)."

	| original |
	original := Current.
	Current := aCursorOrNil.
	UserLibrary default setCursor: Current asParameter.
	^original!

ddCopy
	"Answer the instance that is the OLE DROPEFFECT_COPY cursor."

	DDCopy isNil ifTrue: [
		DDCopy := self fromId: 3 in: (ExternalResourceLibrary open: 'ole32')].

	^DDCopy!

ddCopyScroll
	"Answer the instance that is the OLE DROPEFFECT_COPY | DROPEFFECT_SCROLL cursor."

	DDCopyScroll isNil ifTrue: [
		DDCopyScroll := self fromId: 6 in: (ExternalResourceLibrary open: 'ole32')].

	^DDCopyScroll!

ddLink
	"Answer the instance that is the OLE DROPEFFECT_LINK cursor."

	DDLink isNil ifTrue: [
		DDLink := self fromId: 4 in: (ExternalResourceLibrary open: 'ole32')].

	^DDLink!

ddLinkScroll
	"Answer the instance that is the OLE DROPEFFECT_LINK | DROPEFFECT_SCROLL cursor."

	DDLinkScroll isNil ifTrue: [
		DDLinkScroll := self fromId: 7 in: (ExternalResourceLibrary open: 'ole32')].

	^DDLinkScroll!

ddMove
	"Answer the instance that is the OLE DROPEFFECT_MOVE cursor."

	DDMove isNil ifTrue: [
		DDMove := self fromId: 2 in: (ExternalResourceLibrary open: 'ole32')].

	^DDMove!

ddMoveScroll
	"Answer the instance that is the OLE DROPEFFECT_MOVE | DROPEFFECT_SCROLL cursor."

	DDMoveScroll isNil ifTrue: [
		DDMoveScroll := self fromId: 5 in: (ExternalResourceLibrary open: 'ole32')].

	^DDMoveScroll!

ddNone
	"Answer the instance that is the OLE DROPEFFECT_NONE cursor."

	DDNone isNil ifTrue: [
		DDNone := self fromId: 1 in: (ExternalResourceLibrary open: 'ole32')].

	^DDNone!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size cursor."

	^SystemMetrics current cursorExtent!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Cursor Files (*.cur)' '*.cur')!

hand
	"Answer the instance that is the Help cursor."

	Hand isNil ifTrue: [Hand := self fromSystemId: IDC_HAND].
	^Hand!

help
	"Answer the instance that is the Help cursor."

	Help isNil ifTrue: [Help := self fromSystemId: IDC_HELP].
	^Help!

hide
	"Hide the current cursor"

	self show: false!

iBeam
	"Answer the instance that is the IBeam cursor."

	IBeam isNil ifTrue: [IBeam := self fromSystemId: IDC_IBEAM].
	^IBeam!

icon
	"Answers an Icon that can be used to represent this class"

	^self arrow!

no
	"Answer the instance that is the No cursor."

	No isNil ifTrue: [No := self fromSystemId: IDC_NO].
	^No!

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized cursors to allow
	them to be removed (and also perhaps the ref to the resource library)."

	self uninitialize!

position
	"Answer a Point containing the current cursor position in screen co-ordinates."

	| pos |
	pos := POINTL new.
	UserLibrary default getCursorPos: pos.
	^pos asPoint
!

show
	"Shows the current cursor"

	self show: true!

show: aBoolean
	"Show or hide the current cursor according to aBoolean"

	UserLibrary default showCursor: aBoolean asParameter!

sizeAll
	"Answer the instance that is the SizeAll cursor."

	SizeAll isNil ifTrue: [SizeAll := self fromSystemId: IDC_SIZEALL].
	^SizeAll!

sizeNESW
	"Answer the instance that is the SizeNESW cursor."

	SizeNESW isNil ifTrue: [SizeNESW := self fromSystemId: IDC_SIZENESW].
	^SizeNESW!

sizeNS
	"Answer the instance that is the SizeNS cursor."

	SizeNS isNil ifTrue: [SizeNS := self fromSystemId: IDC_SIZENS].
	^SizeNS!

sizeNWSE
	"Answer the instance that is the SizeNWSE cursor."

	SizeNWSE isNil ifTrue: [SizeNWSE := self fromSystemId: IDC_SIZENWSE].
	^SizeNWSE!

sizeWE
	"Answer the instance that is the SizeWE cursor."

	SizeWE isNil ifTrue: [SizeWE := self fromSystemId: IDC_SIZEWE].
	^SizeWE!

splitHorizontal
	"Answer the instance that is the SplitHorizontal cursor."

	SplitHorizontal isNil ifTrue: [SplitHorizontal := self fromId: 'HSPLIT' in: VMLibrary default].
	^SplitHorizontal!

splitVertical
	"Answer the instance that is the SplitVertical cursor."

	SplitVertical isNil ifTrue: [SplitVertical := self fromId: 'VSPLIT' in: VMLibrary default].
	^SplitVertical!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DDCopy := DDCopyScroll := 
		DDLink := DDLinkScroll := 
		DDMove := DDMoveScroll := 
		DDNone := nil.

	AppStarting := Arrow := Cross := Help := IBeam := No := Wait :=
		SizeAll := SizeNESW := SizeNS := SizeNWSE := SizeWE := 
		SplitHorizontal := SplitVertical := UpArrow := nil.

	Current := nil.!

upArrow
	"Answer the instance that is the UpArrow cursor."

	UpArrow isNil ifTrue: [UpArrow := self fromSystemId: IDC_UPARROW].
	^UpArrow!

wait
	"Answer the instance that is the Wait cursor."

	Wait isNil ifTrue: [Wait := self fromSystemId: IDC_WAIT].
	^Wait! !
!Cursor class categoriesFor: #appStarting!accessing!public! !
!Cursor class categoriesFor: #arrow!instance creation!public! !
!Cursor class categoriesFor: #cross!instance creation!public! !
!Cursor class categoriesFor: #current!accessing!public! !
!Cursor class categoriesFor: #current:!accessing!private! !
!Cursor class categoriesFor: #ddCopy!instance creation!public! !
!Cursor class categoriesFor: #ddCopyScroll!instance creation!public! !
!Cursor class categoriesFor: #ddLink!instance creation!public! !
!Cursor class categoriesFor: #ddLinkScroll!instance creation!public! !
!Cursor class categoriesFor: #ddMove!instance creation!public! !
!Cursor class categoriesFor: #ddMoveScroll!instance creation!public! !
!Cursor class categoriesFor: #ddNone!instance creation!public! !
!Cursor class categoriesFor: #defaultExtent!constants!public! !
!Cursor class categoriesFor: #filesType!constants!private! !
!Cursor class categoriesFor: #hand!instance creation!public! !
!Cursor class categoriesFor: #help!instance creation!public! !
!Cursor class categoriesFor: #hide!operations!public! !
!Cursor class categoriesFor: #iBeam!instance creation!public! !
!Cursor class categoriesFor: #icon!constants!public! !
!Cursor class categoriesFor: #no!instance creation!public! !
!Cursor class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Cursor class categoriesFor: #position!accessing!public! !
!Cursor class categoriesFor: #show!operations!public! !
!Cursor class categoriesFor: #show:!operations!public! !
!Cursor class categoriesFor: #sizeAll!instance creation!public! !
!Cursor class categoriesFor: #sizeNESW!instance creation!public! !
!Cursor class categoriesFor: #sizeNS!instance creation!public! !
!Cursor class categoriesFor: #sizeNWSE!instance creation!public! !
!Cursor class categoriesFor: #sizeWE!instance creation!public! !
!Cursor class categoriesFor: #splitHorizontal!instance creation!public! !
!Cursor class categoriesFor: #splitVertical!instance creation!public! !
!Cursor class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Cursor class categoriesFor: #upArrow!instance creation!public! !
!Cursor class categoriesFor: #wait!instance creation!public! !

