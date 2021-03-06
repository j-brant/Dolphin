"Filed out from Dolphin Smalltalk X6"!

IdentityDictionary variableSubclass: #MethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodDictionary guid: (GUID fromString: '{87B4C530-026E-11D3-9FD7-00A0CC3E4A32}')!
MethodDictionary comment: 'MethodDictionary is a specialized form of <IdentityDictionary> designed for ease and speed of access by the execution machinery. As the name implies, method dictionaries are used to map method selectors to the corresponding compiled method in a particular class.

The primary difference from an ordinary identity dictionary in the current implementation is that method dictionaries are a power of 2 in size to speed up the masking of hash values to the permissible range during method lookup.

You should not rely on the implementation details of this class, and nor should you change them or the instance shape.'!
!MethodDictionary categoriesForClass!Collections-Unordered!Kernel-Support! !
!MethodDictionary methodsFor!

hash: anObject max: anInteger
	"Implementation Note: This must match the selector hashing implementation used by the VM."

	^(anObject hash bitAnd: anInteger - 1) + 1!

removeKey: key ifAbsent: exceptionHandler 
	"Remove the key (and its associated value), from the receiver. If key is not in the 
	receiver, answer the result of evaluating the niladic valuable, exceptionHandler.
	Otherwise, answer the value named by key.
	Implementation Note: Override to perform the update in a copy which is then
	swapped with the receiver. This is to avoid any problems with removing methods
	from the Dictionary hierarchy causing the method dictionaries of these classes
	to become temporarily invalid."

	| index |
	index := self findKeyOrNil: key.
	^(self basicAt: index) isNil 
		ifTrue: [exceptionHandler value]
		ifFalse: 
			[| newMe value |
			value := values basicAt: index.
			newMe := self copy.
			newMe basicValues basicAt: index put: nil.
			newMe removeIndex: index.
			self become: newMe.
			value]! !
!MethodDictionary categoriesFor: #hash:max:!private!searching! !
!MethodDictionary categoriesFor: #removeKey:ifAbsent:!public!removing! !

!MethodDictionary class methodsFor!

sizeFor: capacity
	"Answer the <integer> size of collection that should be created to hold 
	the number of elements specified by the <integer> argument, capacity.
	Implementation Note: Round up to the nearest 	power of 2, as required 
	by the VM, and avoid any dependency on the superclass sizing scheme."

	^capacity < 2
		ifTrue: [2]
		ifFalse: [1 bitShift: (((capacity - 1 * 100 // 75)+1) highBit)]! !
!MethodDictionary class categoriesFor: #sizeFor:!instance creation!public! !

