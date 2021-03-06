"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRSELECTCLIPPATH
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSELECTCLIPPATH guid: (GUID fromString: '{C8B98C6C-58B3-4B3C-A5C6-A65F676491C6}')!
EMRSELECTCLIPPATH comment: '<EMRSELECTCLIPPATH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTCLIPPATH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney�s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C8B98C6C-58B3-4B3C-A5C6-A65F676491C6)]
struct tagEMRSELECTCLIPPATH {
	EMR EMR;
	DWORD iMode;
} EMRSELECTCLIPPATH;
'!
!EMRSELECTCLIPPATH categoriesForClass!Win32-Structs! !
!EMRSELECTCLIPPATH methodsFor!

iMode
	"Answer the receiver's iMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iMode)!

iMode: anObject 
	"Set the receiver's iMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iMode) put: anObject! !
!EMRSELECTCLIPPATH categoriesFor: #iMode!**compiled accessors**!public! !
!EMRSELECTCLIPPATH categoriesFor: #iMode:!**compiled accessors**!public! !

!EMRSELECTCLIPPATH class methodsFor!

defineFields
	"Define the fields of the EMRSELECTCLIPPATH structure.

	EMRSELECTCLIPPATH  compileDefinition

		typedef [uuid(C8B98C6C-58B3-4B3C-A5C6-A65F676491C6)]
		struct tagEMRSELECTCLIPPATH {
			EMR EMR;
			DWORD iMode;
		} EMRSELECTCLIPPATH;
"

	super defineFields.
	self
		defineField: #iMode
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^(Array 
		with: EMR_SELECTCLIPPATH
		with: EMR_SETBKMODE
		with: EMR_SETMAPMODE
		with: EMR_SETLAYOUT
		with: EMR_SETPOLYFILLMODE) , (Array 
					with: EMR_SETROP2
					with: EMR_SETSTRETCHBLTMODE
					with: EMR_SETICMMODE
					with: EMR_SETTEXTALIGN)! !
!EMRSELECTCLIPPATH class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSELECTCLIPPATH class categoriesFor: #iTypes!constants!public! !

