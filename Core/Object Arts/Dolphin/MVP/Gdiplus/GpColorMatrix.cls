"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #GpColorMatrix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpColorMatrix guid: (GUID fromString: '{6B5AB37E-5CC3-447E-99EF-9135F516CCC0}')!
GpColorMatrix comment: '<GpColorMatrix> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorMatrix'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6B5AB37E-5CC3-447E-99EF-9135F516CCC0)]
struct tagGpColorMatrix {
	single m[5][5];
} GpColorMatrix;
'!
!GpColorMatrix categoriesForClass!Unclassified! !
!GpColorMatrix methodsFor!

atPoint: aPoint 
	^self row: aPoint x col: aPoint y!

atPoint: aPoint put: aNumber
	self 
		row: aPoint x
		col: aPoint y
		put: aNumber!

m
	"Answer the receiver's m field as a Smalltalk object."

	^FLOATArray fromAddress: (bytes yourAddress) length: 25!

m: anObject
	"Set the receiver's m field to the value of anObject."

	| size |
	size := anObject byteSize min: (25 * 4).
	anObject replaceBytesOf: bytes from: 1 to: size startingAt: 1!

row: rowInteger col: colInteger 
	^self m at: (rowInteger - 1) * 5 + colInteger!

row: rowInteger col: colInteger put: aNumber
	self m at: (rowInteger - 1) * 5 + colInteger put: aNumber! !
!GpColorMatrix categoriesFor: #atPoint:!accessing!public! !
!GpColorMatrix categoriesFor: #atPoint:put:!accessing!public! !
!GpColorMatrix categoriesFor: #m!**compiled accessors**!public! !
!GpColorMatrix categoriesFor: #m:!**compiled accessors**!public! !
!GpColorMatrix categoriesFor: #row:col:!accessing!public! !
!GpColorMatrix categoriesFor: #row:col:put:!accessing!public! !

!GpColorMatrix class methodsFor!

defineFields
	"Define the fields of the GpColorMatrix structure.
		GpColorMatrix compileDefinition
	
		typedef [uuid(6B5AB37E-5CC3-447E-99EF-9135F516CCC0), helpstring('Color matrix')]
		struct tagGpColorMatrix {
			float m[5][5];
		} GpColorMatrix;
"

	self
		defineField: #m type: (ArrayField type: FLOATArray length: 25) offset: 0.
	self byteSize: 100!

identity
	"Answer an instance of the receiver that represents an identity matrix."

	^self withAll: self identityArray!

identityArray
	"Answer an <Array> which can be used to construct an identity instance.
	Note: do not modify this literal array directly"

	^#(1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1)!

withAll: anArray 
	"Answer an instance created from anArray.
	anArray should have 25 <Magnitude> elements"

	^self new m: (FLOATArray withAll: anArray)! !
!GpColorMatrix class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!GpColorMatrix class categoriesFor: #identity!instance creation!public! !
!GpColorMatrix class categoriesFor: #identityArray!constants!public! !
!GpColorMatrix class categoriesFor: #withAll:!instance creation!public! !

