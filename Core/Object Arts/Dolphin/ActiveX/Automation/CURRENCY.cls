"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #CURRENCY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
CURRENCY guid: (GUID fromString: '{BBE7E662-DE98-4AE2-B820-BAE3E3C6127A}')!
CURRENCY comment: 'CURRENCY is an <ExternalStructure> class to represent the Automation structure of the same name.

CURRENCY is a 64-bit fractional value scaled by 10000 to give 4 decimal places. It provides limited scaled decimal capabilities for simple scripting languages such as VB. It corresponds to the variant type VT_CY.

CURRENCYs are mapped to/from Dolphin''s <ScaledDecimal> objects, although of course the latter has unlimited  range, and therefore many ScaledDecimals cannot be represented in a CURRENCY.'!
!CURRENCY categoriesForClass!External-Data-Structured-COM! !
!CURRENCY methodsFor!

asVariant
	"Answer the <VARIANT> representation of the receiver."

	^(VARIANT new)
		vt: (self vt bitOr: VT_BYREF);
		reference: self;
		yourself!

cy
	"Answer the receiver's cy field as a Smalltalk object."

	^bytes sqwordAtOffset: 0!

cy: anObject 
	"Set the receiver's cy field to the value of anObject."

	bytes sqwordAtOffset: 0 put: anObject!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: (self isNull ifTrue: ['NULL'] ifFalse: [self value]);
		nextPut: $)!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	^(self cy/10000) asScaledDecimal: 4
!

value: newValue
	"Set the receiver's value to the <Number>, newValue."

	self cy: (newValue * 10000) asInteger! !
!CURRENCY categoriesFor: #asVariant!converting!public! !
!CURRENCY categoriesFor: #cy!**compiled accessors**!public! !
!CURRENCY categoriesFor: #cy:!**compiled accessors**!public! !
!CURRENCY categoriesFor: #printOn:!printing!public! !
!CURRENCY categoriesFor: #value!accessing!public! !
!CURRENCY categoriesFor: #value:!accessing!public! !

CURRENCY methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!CURRENCY class methodsFor!

defineFields
	"Define the fields of the CURRENCY 'structure'.

		self compileDefinition
	"

	self defineField: #cy type: SQWORDField new
!

epsilon
	"Answer a <Float> representing the minimum relative spacing
	in the receiver's representation."

	^0.0001
!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

maximum
	^((2 raisedToInteger: 63)-1/10000) asScaledDecimal: 4!

minimum
	^((-2 raisedToInteger: 63)/10000) asScaledDecimal: 4.!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_CY! !
!CURRENCY class categoriesFor: #defineFields!initializing!public! !
!CURRENCY class categoriesFor: #epsilon!constants!public! !
!CURRENCY class categoriesFor: #initialize!development!initializing!private! !
!CURRENCY class categoriesFor: #maximum!constants!public! !
!CURRENCY class categoriesFor: #minimum!constants!public! !
!CURRENCY class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!CURRENCY class categoriesFor: #vt!constants!public! !

