"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #VARIANTTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
VARIANTTest guid: (GUID fromString: '{F436BDF8-12FF-47E4-AD1A-C96795760912}')!
VARIANTTest comment: ''!
!VARIANTTest categoriesForClass!Unclassified! !
!VARIANTTest methodsFor!

isValidNullString: aString 
	self assert: (aString yourAddress asExternalAddress at: 1) == 0.
	self assert: aString = ''.
!

testARRAY
	| var |
	var := #() asVariant.
	self assert: (var vt == (VT_ARRAY|VT_VARIANT)).
	self assert: (var value asArray = #()).
	var := #(1) asVariant.
	self assert: (var vt == (VT_ARRAY|VT_VARIANT)).
	self assert: (var value asArray = #(1)).
	var := #(1 2 3 4) asVariant.
	self assert: (var vt == (VT_ARRAY|VT_VARIANT)).
	self assert: (var value asArray = #(1 2 3 4)).



!

testARRAYREF
	"#1136"
	| var array |
	var := (VARIANT new)
				arrayRef: #();
				yourself.
	self assert: var vt == (VT_BYREF | VT_ARRAY | VT_VARIANT).
	self assert: var value asArray = #().
	array := #(1) asSAFEARRAY.
	var := (VARIANT new)
				arrayRef: array;
				yourself.
	self assert: var vt == (VT_BYREF | VT_ARRAY | VT_VARIANT).
	self assert: var value asArray = #(1).
	array at: 1 put: 2.
	self assert: var value asArray = #(2).
	array := (DWORDArray withAll: #(1 2 3 4)) asSAFEARRAY.
	var := (VARIANT new)
				arrayRef: array;
				yourself.
	self assert: var vt == (VT_BYREF | VT_ARRAY | VT_UI4).
	self assert: var value asArray = #(1 2 3 4).
	1 to: 4 do: [:each | array at: each put: each * each].
	self assert: var value asArray = #(1 4 9 16)!

testBSTR
	| var |
	var := VARIANT new.
	var bstr: 'abc'.
	self assert: var vt == VT_BSTR.
	self assert: var value = 'abc'.
	var ulVal: 0.
	self isValidNullString: var value.
	var bstr: ''.
	self isValidNullString: var value.
	var := (OLEAutLibrary default sysAllocString: '') asVariant.
	"Make sure there is a junk value in the free list"
	'abc' copy.
	self isValidNullString: var value "yourAddress asExternalAddress at: 1"
!

testCollectionConversions
	| bytes var array sa |
	array := #(0 1234 1.234 'abc' 16r7FFFFFFF -16r80000000).
	self class supportsI8 ifTrue: [array := array , #(16r80000000 16rFFFFFFFF 16rFFFFFFFFFFFFFFFF)].
	var := array asVariant.
	self assert: var vt = (VT_ARRAY | VT_VARIANT).
	sa := var value.
	self assert: sa asArray = array.
	"Test ByteArray converts to VT_ARRAY|VT_UI1"
	bytes := #[1 2 3].
	var := bytes asVariant.
	self assert: var vt = (VT_ARRAY | VT_UI1).
	self assert: var value asArray asByteArray = bytes.
	"External array types"
	#(#DOUBLEArray #FLOATArray #DWORDArray #SDWORDArray #WORDArray #SWORDArray) do: 
			[:each | 
			| class |
			class := Smalltalk at: each.
			array := class withAll: #(1 2 3).
			var := array asVariant.
			self assert: var vt = (VT_ARRAY | array elementClass vt).
			self assert: var value asArray = array]!

testCY
	| var |
	var := VARIANT new.
	var cy: 0.0.
	self assert: var vt == VT_CY.
	self assert: var value = 0.
	var cy: 1234.1234s.
	self assert: var value = 1234.1234s.
	var cy: CURRENCY maximum.
	self assert: var value = CURRENCY maximum.
	var cy: CURRENCY minimum.
	self assert: var value = CURRENCY minimum!

testCYREF
	| var cy |
	var := VARIANT new.
	cy := CURRENCY new value: 1234.1234s.
	var := cy asVariant.
	self assert: (var vt == (VT_CY|VT_BYREF)).
	self assert: (var value = cy).
	self assert: (var value yourAddress = cy yourAddress).
	var value value: 5678.5678s.
	self assert: cy value = 5678.5678s.!

testDATE
	| var date |
	var := VARIANT new.
	date := DATE new.
	var := var date: date.
	self assert: var vt == VT_DATE.
	self assert: var value = date.
	var date: DATE maximum.
	self assert: var value = DATE maximum.
	var date: DATE minimum.
	self assert: var value = DATE minimum!

testDISPATCH
	| var obj val |
	obj := IDispatch createObject: 'Internet.HHCtrl'.
	self assert: obj referenceCount == 1.
	var := VARIANT new.
	var dispatch: obj.
	self assert: obj referenceCount == 2.
	val := var value.
	self assert: (val referenceCount == 3).
	val free. 
	self assert: (var value referenceCount == 3).
	self assert: (var value class == IDispatch).
	self assert: (var value isSameCOMObject: obj).
!

testDISPATCHREF
	| var obj val |
	obj := IDispatch createObject: 'Internet.HHCtrl'.
	self assert: obj referenceCount == 1.
	var := VARIANT new.
	var vt: (VT_DISPATCH|VT_BYREF).
	var reference: obj bytes basicYourAddress.
	self assert: obj referenceCount == 1.
	val := var value.
	self assert: obj referenceCount == 1.
	val free. 
	self assert: obj referenceCount == 1.
	self assert: ((var value value asExternalAddress) = obj bytes).
!

testEMPTY
	| var |
	var := VARIANT new.
	var nil: nil.
	self assert: (var vt == VT_EMPTY).
	self assert: (var value isNil).!

testFromAddress
	| v1 v2 |
	v1 := 'abc' asVariant.
	v2 := VARIANT fromAddress: v1 yourAddress.
	self assert: v2 value = 'abc'.
	self deny: v1 isByRef.
	self deny: v2 isFinalizable.
	self deny: v2 needsFree.
	v2 free.
	self assert: v1 value = 'abc'!

testFromInteger
	| var |
	#(-16r80000000 -16r7FFFFFFF -2 -1 0 1 2 16r7FFFFFFE 16r7FFFFFFF) do: 
			[:each | 
			var := each asVariant.
			self assert: var vt = VT_I4.
			self assert: var value = each].
	#(-16r8000000000000000 -16r7FFFFFFFFFFFFFFF -16r80000001 16r80000000 16r7FFFFFFFFFFFFFFF) 
		do: 
			[:each | 
			var := each asVariant.
			self assert: var vt = VT_I8.
			self assert: var value = each].
	#(16r8000000000000000 16r8000000000000001 16rFFFFFFFFFFFFFFFE 16rFFFFFFFFFFFFFFFF) do: 
			[:each | 
			var := each asVariant.
			self assert: var vt = VT_UI8.
			self assert: var value = each].
	#(-16r8000000000000001 16r10000000000000001) 
		do: [:each | self should: [each asVariant] raise: Error]!

testI1
	| var |
	var := VARIANT new.
	var sbyte: 0.
	self assert: (var vt == VT_I1).
	self assert: (var value == 0).
	var sbyte: 127.
	self assert: (var value == 127).
	self should: [var sbyte: 128] raise: Error.
	var sbyte: -128.
	self assert: (var value == -128).
	self should: [var sbyte: 129] raise: Error.
!

testI1REF
	| var byte |
	byte := SBYTE new value: 127.
	var := byte asVariant.
	self assert: var vt == (VT_I1 | VT_BYREF).
	self assert: var value = byte.
	self assert: var value yourAddress = byte yourAddress.
	var value value: -128.
	self assert: byte value = -128!

testI2
	| var |
	var := VARIANT new.
	var sword: 0.
	self assert: (var vt == VT_I2).
	self assert: (var value == 0).
	var sword: 32767.
	self assert: (var value == 32767).
	self should: [var sword: 32768] raise: Error.
	var sword: -32768.
	self assert: (var value == -32768).
	self should: [var sword: -32769] raise: Error.
!

testI2REF
	| var sword |
	sword := SWORD new value: 32767.
	var := sword asVariant.
	self assert: var vt == (VT_I2 | VT_BYREF).
	self assert: var value = sword.
	self assert: var value yourAddress = sword yourAddress.
	var value value: -32768.
	self assert: sword value = -32768!

testI4
	| var |
	var := VARIANT new.
	var sdword: 0.
	self assert: (var vt == VT_I4).
	self assert: (var value == 0).
	var sdword: 2147483647.
	self assert: (var value = 2147483647).
	self should: [var sdword: 2147483648] raise: Error.
	var sdword: -2147483648.
	self assert: (var value = -2147483648).
	self should: [var sdword: -2147483649] raise: Error.
!

testI4REF
	| var sdword |
	sdword := SDWORD new value: 2147483647.
	var := sdword asVariant.
	self assert: var vt == (VT_I4 | VT_BYREF).
	self assert: var value = sdword.
	self assert: var value yourAddress = sdword yourAddress.
	var value value: -2147483648.
	self assert: sdword value = -2147483648!

testI8
	| var copy |
	var := VARIANT new.
	var sqword: 0.
	self assert: var vt == VT_I8.
	self assert: var value == 0.
	var sqword: 2 ** 63 - 1.
	self assert: var value = (2 ** 63 - 1).
	self should: [var sqword: 2 ** 63] raise: Error.
	var sqword: -2 ** 63.
	self assert: var value = (-2 ** 63).
	self should: [var sqword: -2 ** 63 - 1] raise: Error.
	self class supportsI8 ifFalse: [^self].
	copy := var copy.
	self assert: copy vt = VT_I8.
	self assert: copy value = var value!

testINT
	| var |
	var := VARIANT new.
	var sdword: 0.
	var vt: VT_INT.
	self assert: (var value == 0).
	var sdword: 2147483647; 	vt: VT_INT.
	self assert: (var value = 2147483647).
	var sdword: -2147483648; vt: VT_INT.
	self assert: (var value = -2147483648).
!

testNULL
	| var |
	var := VARIANT new.
	var null: nil.
	self assert: (var vt == VT_NULL).
	self assert: (var value isNil).!

testR4
	| var max min |
	var := VARIANT new.
	var float: 0.0.
	self assert: (var vt == VT_R4).
	self assert: (var value = 0.0).
	max := FLOAT maximum value.
	var float: max.
	self assert: (var value equals: max).
	self should: [var float: max*10] raise: Error.
	var float: -1*max.
	self assert: (var value equals: (-1*max)).
	self should: [var float: (-10*max)] raise: Error.
	min := FLOAT minimum value.
	var float: min.
	self assert: (var value equals: min).
!

testR4REF
	| var float |
	float := FLOAT maximum copy.
	var := float asVariant.
	self assert: var vt == (VT_R4 | VT_BYREF).
	self assert: var value = float.
	self assert: var value yourAddress = float yourAddress.
	var value value: FLOAT minimum value.
	self assert: (float value equals: FLOAT minimum value)!

testR8
	| var |
	var := VARIANT new.
	var double: 0.0.
	self assert: var vt == VT_R8.
	self assert: var value = 0.0.
	var double: -1.0.
	self assert: (var value equals: -1.0).
	var double: Float fmax.
	self assert: (var value equals: Float fmax).
	var double: Float fmin.
	self assert: (var value equals: Float fmin)!

testR8REF
	| var double |
	double := DOUBLE new value: Float fmax.
	var := double asVariant.
	self assert: var vt == (VT_R8 | VT_BYREF).
	self assert: var value = double.
	self assert: var value yourAddress = double yourAddress.
	var value value: Float fmin.
	self assert: (double value equals: Float fmin)!

testUI1
	| var |
	var := VARIANT new.
	var byte: 0.
	self assert: (var vt == VT_UI1).
	self assert: (var value == 0).
	var byte: 255.
	self assert: (var value == 255).
	self should: [var byte: 256] raise: Error.
	self should: [var byte: -1] raise: Error.
!

testUI1REF
	| var byte |
	byte := BYTE new value: 255.
	var := byte asVariant.
	self assert: var vt == (VT_UI1 | VT_BYREF).
	self assert: var value = byte.
	self assert: var value yourAddress = byte yourAddress.
	var value value: 128.
	self assert: byte value = 128!

testUI2
	| var |
	var := VARIANT new.
	var word: 0.
	self assert: (var vt == VT_UI2).
	self assert: (var value == 0).
	var word: 65535.
	self assert: (var value == 65535).
	self should: [var word: 65536] raise: Error.
	self should: [var word: -1] raise: Error.
!

testUI2REF
	| var word |
	word := WORD new value: 65535.
	var := word asVariant.
	self assert: var vt == (VT_UI2 | VT_BYREF).
	self assert: var value = word.
	self assert: var value yourAddress = word yourAddress.
	var value value: 32768.
	self assert: word value = 32768!

testUI4
	| var |
	var := VARIANT new.
	var dword: 0.
	self assert: (var vt == VT_UI4).
	self assert: (var value == 0).
	var dword: 0.0.
	self assert: (var vt == VT_UI4).
	self assert: (var value == 0).
	var dword: 4294967295.
	self assert: (var value = 4294967295).
	self should: [var dword: 4294967296] raise: Error.
	"dwordAtOffset:put: is unusual in accepting negative values"
	var dword: -1.
	self assert: (var value = 4294967295).

!

testUI4REF
	| var dword |
	dword := DWORD new value: 4294967295.
	var := dword asVariant.
	self assert: var vt == (VT_UI4 | VT_BYREF).
	self assert: var value = dword.
	self assert: var value yourAddress = dword yourAddress.
	var value value: 2147483648.
	self assert: dword value = 2147483648!

testUI8
	| var |
	var := VARIANT new.
	var qword: 0.
	self assert: var vt == VT_UI8.
	self assert: var value == 0.
	var qword: 0.0.
	self assert: var vt == VT_UI8.
	self assert: var value == 0.
	var qword: 2 ** 63.
	self assert: var value = (2 ** 63).
	var qword: 2 ** 64 - 1.
	self assert: var value = (2 ** 64 - 1).
	self should: [var qword: 2 ** 64] raise: Error.
	"dwordAtOffset:put: is unusual in accepting negative values"
	var qword: -1.
	self assert: var value = (2 ** 64 - 1)! !
!VARIANTTest categoriesFor: #isValidNullString:!private!testing! !
!VARIANTTest categoriesFor: #testARRAY!public!unit tests! !
!VARIANTTest categoriesFor: #testARRAYREF!public!unit tests! !
!VARIANTTest categoriesFor: #testBSTR!public!unit tests! !
!VARIANTTest categoriesFor: #testCollectionConversions!public!unit tests! !
!VARIANTTest categoriesFor: #testCY!public!unit tests! !
!VARIANTTest categoriesFor: #testCYREF!public!unit tests! !
!VARIANTTest categoriesFor: #testDATE!public!unit tests! !
!VARIANTTest categoriesFor: #testDISPATCH!public!unit tests! !
!VARIANTTest categoriesFor: #testDISPATCHREF!public!unit tests! !
!VARIANTTest categoriesFor: #testEMPTY!public!unit tests! !
!VARIANTTest categoriesFor: #testFromAddress!public!unit tests! !
!VARIANTTest categoriesFor: #testFromInteger!public!unit tests! !
!VARIANTTest categoriesFor: #testI1!public!unit tests! !
!VARIANTTest categoriesFor: #testI1REF!public!unit tests! !
!VARIANTTest categoriesFor: #testI2!public!unit tests! !
!VARIANTTest categoriesFor: #testI2REF!public!unit tests! !
!VARIANTTest categoriesFor: #testI4!public!unit tests! !
!VARIANTTest categoriesFor: #testI4REF!public!unit tests! !
!VARIANTTest categoriesFor: #testI8!public!unit tests! !
!VARIANTTest categoriesFor: #testINT!public!unit tests! !
!VARIANTTest categoriesFor: #testNULL!public!unit tests! !
!VARIANTTest categoriesFor: #testR4!public!unit tests! !
!VARIANTTest categoriesFor: #testR4REF!public!unit tests! !
!VARIANTTest categoriesFor: #testR8!public!unit tests! !
!VARIANTTest categoriesFor: #testR8REF!public!unit tests! !
!VARIANTTest categoriesFor: #testUI1!public!unit tests! !
!VARIANTTest categoriesFor: #testUI1REF!public!unit tests! !
!VARIANTTest categoriesFor: #testUI2!public!unit tests! !
!VARIANTTest categoriesFor: #testUI2REF!public!unit tests! !
!VARIANTTest categoriesFor: #testUI4!public!unit tests! !
!VARIANTTest categoriesFor: #testUI4REF!public!unit tests! !
!VARIANTTest categoriesFor: #testUI8!public!unit tests! !

!VARIANTTest class methodsFor!

supportsI8
	^OSVERSIONINFO current isWinXPOrLater! !
!VARIANTTest class categoriesFor: #supportsI8!private!testing! !

