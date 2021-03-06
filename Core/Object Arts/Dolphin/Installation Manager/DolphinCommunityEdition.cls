"Filed out from Dolphin Smalltalk 7"!

DolphinBaseProduct subclass: #DolphinCommunityEdition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinCommunityEdition guid: (GUID fromString: '{97AC6BC9-3516-42C9-845B-A5ED3579F331}')!
DolphinCommunityEdition comment: ''!
!DolphinCommunityEdition categoriesForClass!Development! !
!DolphinCommunityEdition methodsFor!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Community Edition'!

installSystemFolderOptions
	Smalltalk at: #SmalltalkSystemShell
		ifPresent: 
			[:systemFolder | 
			systemFolder
				defaultExtent: (self calcSystemFolderExtentFor: 760 @ 355);
				backcolor: self defaultSystemFolderColor]!

preShrink
	"Private - Perform any pre-shrinkage actions. "

	"In this case we want to remove any ImageStripper bytes
	because they contain references to Lagoon, which only belongs in DolphinProfessional"

	self packages do: [:each | each imageStripperBytes: nil]! !
!DolphinCommunityEdition categoriesFor: #fullName!accessing!public! !
!DolphinCommunityEdition categoriesFor: #installSystemFolderOptions!private! !
!DolphinCommunityEdition categoriesFor: #preShrink!private! !

!DolphinCommunityEdition class methodsFor!

isAbstract
	^false!

productLevel
	"Private - Answer the product ID for the receiver"

	^1!

productName
	"Answer the product name"
	
	^'Community Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCE'! !
!DolphinCommunityEdition class categoriesFor: #isAbstract!operations!public!testing! !
!DolphinCommunityEdition class categoriesFor: #productLevel!constants!private! !
!DolphinCommunityEdition class categoriesFor: #productName!accessing!public! !
!DolphinCommunityEdition class categoriesFor: #shortProductName!accessing!public! !

