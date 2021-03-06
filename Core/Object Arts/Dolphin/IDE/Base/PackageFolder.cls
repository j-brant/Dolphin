"Filed out from Dolphin Smalltalk X6.2"!

Folder subclass: #PackageFolder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageFolder guid: (GUID fromString: '{78425858-C3B5-4314-847A-772FF5268A84}')!
PackageFolder comment: ''!
!PackageFolder categoriesForClass!Development! !
!PackageFolder methodsFor!

icon
	"Answer an <Icon> to use when representing the receiver"

	^self isDolphinFolder 
		ifTrue: [Icon fromId: 'DOLPHINPACKAGEFOLDER.ICO']
		ifFalse: [super icon]!

isDolphinFolder
	"Private - Answer true if the receiver represents a Dolphin base system package folder"

	^self canonicalPath beginsWith: self class dolphinRootPathname!

rootName
	"Private - Answer the name to use for the folder at the root of the current image hierarchy"

	^'$'! !
!PackageFolder categoriesFor: #icon!constants!public! !
!PackageFolder categoriesFor: #isDolphinFolder!private!testing! !
!PackageFolder categoriesFor: #rootName!constants!private! !

!PackageFolder class methodsFor!

dolphinRoot
	"Answer an instance of the receiver representing the current dolphin package hierarchy"

	^self pathname: self dolphinRootPathname!

dolphinRootPathname
	^'core\'!

forPackage: aPackage 
	"Answer an instance of the receiver for the folder of aPackage"

	^self pathname: aPackage packageFolder! !
!PackageFolder class categoriesFor: #dolphinRoot!instance creation!public! !
!PackageFolder class categoriesFor: #dolphinRootPathname!constants!instance creation!public! !
!PackageFolder class categoriesFor: #forPackage:!instance creation!public! !

