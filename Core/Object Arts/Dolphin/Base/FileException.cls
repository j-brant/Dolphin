"Filed out from Dolphin Smalltalk X6"!

Win32Error subclass: #FileException
	instanceVariableNames: 'file resumable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileException guid: (GUID fromString: '{87B4C566-026E-11D3-9FD7-00A0CC3E4A32}')!
FileException comment: ''!
!FileException categoriesForClass!File-Exception Handling! !
!FileException methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	^super _descriptionArguments copyWith: file name!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'''%4'' - %3'!

file
	"Answer the receiver's file instance var."

	^file
!

isResumable
	"Answer whether the receiver represents a resumable error."

	^resumable!

setFile: aFile resumable: aBoolean 
	file := aFile.
	resumable := aBoolean! !
!FileException categoriesFor: #_descriptionArguments!displaying!public! !
!FileException categoriesFor: #_descriptionFormat!displaying!public! !
!FileException categoriesFor: #file!accessing!public! !
!FileException categoriesFor: #isResumable!public!testing! !
!FileException categoriesFor: #setFile:resumable:!accessing!private! !

!FileException class methodsFor!

on: aFile 
	"Answer an instance of the receiver detailing an operating system error
	on the given file."

	^self on: aFile resumable: false!

on: aFile resumable: aBoolean 
	^(self new)
		setFile: aFile resumable: aBoolean;
		yourself!

signalOn: aFile 
	"Signal an instance of the receiver detailing an operating system error
	on the given file."

	^self signalOn: aFile resumable: false!

signalOn: aFile resumable: aBoolean 
	^(self on: aFile resumable: aBoolean) signal! !
!FileException class categoriesFor: #on:!instance creation!public! !
!FileException class categoriesFor: #on:resumable:!instance creation!public! !
!FileException class categoriesFor: #signalOn:!instance creation!public! !
!FileException class categoriesFor: #signalOn:resumable:!instance creation!public! !

